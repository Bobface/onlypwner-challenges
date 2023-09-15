pragma solidity 0.8.19;

interface IPetition {
    function initialize() external;

    function signSupport(Signature calldata signature) external;

    function signReject(Signature calldata signature) external;

    function finishPetition() external;

    function owner() external view returns (address);

    function isFinished() external view returns (bool);

    function supportDigest() external view returns (bytes32);

    function rejectDigest() external view returns (bytes32);

    struct Signature {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    struct StoragePointer {
        uint256 value;
    }

    event Signed(address indexed signer, bool isSupport);
}
