pragma solidity ^0.8.20;

interface IBridge {
    struct ValidatorInfo {
        uint256 deposit;
        address referrer;
        bytes32 tag;
    }

    function voteForNewRoot(bytes calldata vote) external;

    function registerValidator(address referrer, bytes32 tag) external payable;

    function addAdmin(address admin) external;

    function owner() external view returns (address);

    function admins(uint256) external view returns (address);

    function validators(address) external view returns (ValidatorInfo memory);

    function votedOn(bytes32, address) external view returns (bool);

    function votesFor(bytes32) external view returns (uint256);

    function stateRoot() external view returns (bytes32);

    event ValidatorRegistered(address indexed validator, bytes32 tag);
    event ValidatorUnregistered(address indexed validator);
    event ValidatorActivated(address indexed validator);
    event ValidatorDisabled(address indexed validator);

    event NewStateRoot(bytes32 indexed stateRoot, bytes32 indexed validatorTag);
}
