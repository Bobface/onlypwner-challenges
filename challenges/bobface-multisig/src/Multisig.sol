pragma solidity 0.8.20;

import {IMultisig} from "./interfaces/IMultisig.sol";
import {ECDSA} from "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

/*
    A multisignature wallet that uses a threshold of signatures
    to execute transactions. A novel mechanism is deployed: 
    users can veto a transaction by submitting an "against" vote,
    which causes the score to decrease by 1. Users can also submit
    both "for" and "against" votes, which in essence is an abstain.
*/
contract Multisig is IMultisig {
    address[] public override owners;
    uint256 public override threshold;
    PendingTransaction[] private pendingTransactions;
    mapping(bytes32 => bool) public override receivedPayloads;

    uint256 public constant override DEADLINE = 48 hours;

    modifier onlyOwner() {
        require(isOwner(msg.sender), "only-owner");
        _;
    }

    modifier onlySelf() {
        require(msg.sender == address(this), "only-self");
        _;
    }

    constructor(address[] memory owners_, uint256 threshold_) {
        require(owners_.length > 0, "owners");
        require(threshold_ > 0, "threshold");

        owners = owners_;
        threshold = threshold_;

        emit NewThreshold(0, threshold_);
        for (uint256 i = 0; i < owners_.length; i++) {
            emit NewOwner(owners_[i]);
        }
    }

    function proposeTransaction(
        address target,
        uint256 value,
        bytes calldata cdata
    ) external override onlyOwner returns (uint256) {
        uint256 id = pendingTransactions.length;
        pendingTransactions.push(
            PendingTransaction({
                target: target,
                value: value,
                cdata: cdata,
                deadline: block.timestamp + DEADLINE,
                score: 0,
                executed: false
            })
        );

        emit TransactionQueued(id);

        return id;
    }

    /*
        Payload format: 
        v, r, s, id, isFor, contractAddress, chainId, signer, signerIndex
        For simplicity, all fields use 32 bytes.
    */
    function submit(bytes calldata payload) external override {
        // Validate the payload format
        bytes32 hash = validatePayloadFormat(payload);
        receivedPayloads[hash] = true;

        // Verify the payload
        (uint256 id, bool isFor, address signer) = verifyPayload(payload);

        // Check the pending transaction
        PendingTransaction memory pending = pendingTransactions[id];
        require(block.timestamp < pending.deadline, "deadline");
        require(!pending.executed, "already-executed");

        // Update the score and check for execution
        bool doExecute = updateScore(id, isFor);
        emit VoteReceived(signer, id, isFor);

        if (!doExecute) {
            return;
        }

        // Execute the transaction
        pendingTransactions[id].executed = true;
        bool success = execute(pending);

        // Check for success
        if (success) {
            emit TransactionExecuted(id);
        } else {
            pendingTransactions[id].executed = false;
            emit TransactionReverted(id);
        }
    }

    function execute(PendingTransaction memory pending) private returns (bool) {
        (bool success, ) = pending.target.call{value: pending.value}(
            pending.cdata
        );
        return success;
    }

    function addOwner(address newOwner) external override onlySelf {
        require(!isOwner(newOwner), "already-owner");
        owners.push(newOwner);
        emit NewOwner(newOwner);
    }

    function removeOwner(address remOwner) external override onlySelf {
        uint256 index = type(uint256).max;
        for (uint256 i = 0; i < owners.length; i++) {
            if (remOwner == owners[i]) {
                index = i;
                break;
            }
        }

        require(index != type(uint256).max, "not-owner");
        owners[index] = owners[owners.length - 1];
        owners.pop();
        emit RemovedOwner(remOwner);
    }

    function setThreshold(uint256 newThreshold) external override onlySelf {
        uint256 oldThreshold = threshold;
        threshold = newThreshold;
        emit NewThreshold(oldThreshold, newThreshold);
    }

    function updateScore(uint256 id, bool isFor) private returns (bool) {
        unchecked {
            if (isFor) {
                int256 score = pendingTransactions[id].score + 1;
                pendingTransactions[id].score = score;
                return score > 0 && uint256(score) >= threshold;
            } else {
                pendingTransactions[id].score -= 1;
                return false;
            }
        }
    }

    function validatePayloadFormat(
        bytes calldata payload
    ) public view override returns (bytes32) {
        uint256 expectedPayloadLength = 0x120;
        uint256 expectedCalldataLength = 4 + 32 + 32 + expectedPayloadLength;
        require(msg.data.length == expectedCalldataLength, "calldata-length");
        require(payload.length == expectedPayloadLength, "payload-length");

        bytes32 hash = keccak256(msg.data[4:expectedCalldataLength]);
        require(!receivedPayloads[hash], "already-received");

        return hash;
    }

    function verifyPayload(
        bytes calldata payload
    ) public view returns (uint256, bool, address) {
        // Extract the fields from the payload
        // Uglyness © stack too deep
        uint8 v;
        {
            uint256 rawV = uint256(bytes32(payload[0x00:0x20]));
            require(v <= type(uint8).max, "v");
            v = uint8(rawV);
        }
        bytes32 r = bytes32(payload[0x20:0x40]);
        bytes32 s = bytes32(payload[0x40:0x60]);
        uint256 id = uint256(bytes32(payload[0x60:0x80]));
        uint256 isFor = uint256(bytes32(payload[0x80:0xA0]));
        address contractAddress;
        address signer;
        {
            uint256 rawContractAddress = uint256(bytes32(payload[0xA0:0xC0]));
            uint256 rawSigner = uint256(bytes32(payload[0xE0:0x100]));
            require(rawSigner <= type(uint160).max, "signer");
            require(
                rawContractAddress <= type(uint160).max,
                "contract-address"
            );
            signer = address(uint160(rawSigner));
            contractAddress = address(uint160(rawContractAddress));
        }
        uint256 chainId = uint256(bytes32(payload[0xC0:0xE0]));
        uint256 signerIndex = uint256(bytes32(payload[0x100:0x120]));

        // Get the hash to be signed
        bytes32 hash = keccak256(
            abi.encode(id, isFor, contractAddress, chainId, signer, signerIndex)
        );

        // Validate the fields
        require(isFor == 0 || isFor == 1, "is-for");
        require(contractAddress == address(this), "contract-address");
        require(chainId == block.chainid, "chain-id");
        require(
            ECDSA.recover(hash, uint8(v), r, s) == signer,
            "invalid-signer"
        );
        require(signerIndex == getOwnerIndex(signer), "signer-index");

        return (id, isFor == 1, signer);
    }

    function parsePayload(
        bytes calldata payload
    ) public pure override returns (bytes1, bytes32, bytes32, uint256, bool) {
        bytes1 v = payload[0];
        bytes32 r = bytes32(payload[1:33]);
        bytes32 s = bytes32(payload[33:65]);
        uint256 id = uint256(bytes32(payload[65:97]));
        bool isFor = uint8(payload[97]) == 1;

        return (v, r, s, id, isFor);
    }

    function isOwner(address owner) public view override returns (bool) {
        for (uint256 i = 0; i < owners.length; i++) {
            if (owner == owners[i]) {
                return true;
            }
        }

        return false;
    }

    function getOwnerIndex(
        address owner
    ) public view override returns (uint256) {
        for (uint256 i = 0; i < owners.length; i++) {
            if (owner == owners[i]) {
                return i;
            }
        }

        revert("not-owner");
    }

    function getPendingTransaction(
        uint256 index
    ) public view override returns (PendingTransaction memory) {
        return pendingTransactions[index];
    }

    function getChainId() external view override returns (uint256) {
        return block.chainid;
    }

    receive() external payable {}
}
