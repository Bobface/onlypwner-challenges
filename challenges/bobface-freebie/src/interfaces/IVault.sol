pragma solidity 0.8.19;

interface IVault {
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    function deposit() external payable;

    function withdraw(uint256 amount) external;
}
