pragma solidity ^0.8.20;

interface IStunt {
    function attempt(address target) external;

    function claimReward(address target) external;

    function withdraw() external;

    function owner() external returns (address);

    function solved(address) external returns (bool);

    function claimed(address) external returns (bool);
}
