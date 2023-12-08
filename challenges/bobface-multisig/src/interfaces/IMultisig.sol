pragma solidity 0.8.20;

interface IMultisig {
    struct PendingTransaction {
        address target;
        uint256 value;
        bytes cdata;
        uint256 deadline;
        int256 score;
        bool executed;
    }

    event TransactionQueued(uint256 indexed index);
    event NewOwner(address indexed owner);
    event RemovedOwner(address indexed owner);
    event NewThreshold(
        uint256 indexed oldThreshold,
        uint256 indexed newThreshold
    );
    event VoteReceived(address indexed owner, uint256 indexed id, bool isFor);
    event TransactionExecuted(uint256 indexed id);
    event TransactionReverted(uint256 indexed id);

    function owners(uint256 index) external view returns (address);

    function threshold() external view returns (uint256);

    function getPendingTransaction(
        uint256 index
    ) external view returns (PendingTransaction memory);

    function receivedPayloads(bytes32 index) external view returns (bool);

    function DEADLINE() external view returns (uint256);

    function proposeTransaction(
        address target,
        uint256 value,
        bytes calldata cdata
    ) external returns (uint256);

    function submit(bytes calldata payload) external;

    function addOwner(address newOwner) external;

    function removeOwner(address remOwner) external;

    function setThreshold(uint256 newThreshold) external;

    function validatePayloadFormat(
        bytes calldata payload
    ) external view returns (bytes32);

    function parsePayload(
        bytes calldata payload
    ) external pure returns (bytes1, bytes32, bytes32, uint256, bool);

    function isOwner(address owner) external view returns (bool);

    function getOwnerIndex(address owner) external view returns (uint256);

    function getChainId() external view returns (uint256);
}
