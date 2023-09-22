pragma solidity 0.8.20;

interface IDistributor {
    function withdraw(bytes calldata params, bytes32[] calldata proof) external;

    function root() external view returns (bytes32);

    function hasClaimed(address account) external view returns (bool);
}
