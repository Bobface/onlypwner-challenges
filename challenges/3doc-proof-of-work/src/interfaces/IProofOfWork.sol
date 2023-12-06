pragma solidity 0.8.21;

interface IProofOfWork {
    // grab the coins
    function withdraw(uint256 amount) external;

    // request a new assignment for the "newOwner" candidate
    function submitAssignment(address newOwner, uint256 referralCode) external;

    // check that "newOwner" has completed their assignment
    function checkAssignment(address newOwner) external;
}