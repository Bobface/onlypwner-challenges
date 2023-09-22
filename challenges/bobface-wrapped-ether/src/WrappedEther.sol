pragma solidity 0.8.20;

import {IWrappedEther} from "./interfaces/IWrappedEther.sol";

contract WrappedEther is IWrappedEther {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function deposit(address to) external payable {
        balanceOf[to] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "insufficient balance");
        balanceOf[msg.sender] -= amount;
        sendEth(payable(msg.sender), amount);
        emit Withdraw(msg.sender, amount);
    }

    function withdrawAll() external {
        sendEth(payable(msg.sender), balanceOf[msg.sender]);
        balanceOf[msg.sender] = 0;
        emit Withdraw(msg.sender, balanceOf[msg.sender]);
    }

    function transfer(address to, uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) external {
        require(balanceOf[from] >= amount, "insufficient balance");
        require(
            allowance[from][msg.sender] >= amount,
            "insufficient allowance"
        );
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        allowance[from][msg.sender] -= amount;
        emit Transfer(from, to, amount);
    }

    function approve(address spender, uint256 amount) external {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
    }

    function sendEth(address payable to, uint256 amount) private {
        (bool success, ) = to.call{value: amount}("");
        require(success, "failed to send ether");
    }
}
