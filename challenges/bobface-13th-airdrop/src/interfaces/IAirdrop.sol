pragma solidity =0.8.13;

interface IAirdrop {
    function claim(address recipient) external;

    function addRecipient(address recipient) external payable;

    function balances(address who) external view returns (uint256);
}
