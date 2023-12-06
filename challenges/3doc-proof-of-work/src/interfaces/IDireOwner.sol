pragma solidity 0.8.21;

interface IDireOwner {
    function workMyDirefulOwner(uint256 referralCode, uint256 challenge) external returns(uint256 bet);
    function proofOfDreadfulWork() external view returns (uint256 proof);
}