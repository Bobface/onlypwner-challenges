pragma solidity 0.8.19;

import {IVault} from "./interfaces/IVault.sol";

contract Vault is IVault {
    uint256 public totalDeposited;

    function deposit() external payable {
        totalDeposited += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        totalDeposited -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }
}
