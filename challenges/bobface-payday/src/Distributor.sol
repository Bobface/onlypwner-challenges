pragma solidity 0.8.20;

import {MerkleProof} from "./MerkleProof.sol";
import {IDistributor} from "./interfaces/IDistributor.sol";

contract Distributor is IDistributor {
    bytes32 public root;
    mapping(address => bool) public hasClaimed;

    constructor(bytes32 _root) payable {
        root = _root;
    }

    function withdraw(
        bytes calldata params,
        bytes32[] calldata proof
    ) external {
        require(params.length == 64, "invalid params");

        bytes32 leaf = keccak256(params);
        require(MerkleProof.verifyProof(leaf, root, proof), "invalid proof");

        (address recipient, uint72 amount, uint184 validUntil) = decodeParams(
            params
        );

        require(!hasClaimed[recipient], "already claimed");
        require(validUntil >= block.timestamp, "expired");

        hasClaimed[recipient] = true;
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "failed to send ether");
    }

    function decodeParams(
        bytes memory params
    ) private pure returns (address, uint72, uint184) {
        bytes32 first;
        bytes32 second;

        assembly {
            first := mload(add(params, 0x20))
            second := mload(add(params, 0x40))
        }

        address recipient = address(uint160(uint256(first)));
        uint72 amount = uint72(uint256(second) >> 184);
        uint184 validUntil = uint184(uint256(second) >> 72);

        return (recipient, amount, validUntil);
    }
}
