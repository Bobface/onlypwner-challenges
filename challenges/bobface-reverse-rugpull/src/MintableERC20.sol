pragma solidity ^0.8.20;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MintableERC20 is ERC20 {
    constructor(
        string memory name,
        string memory symbol,
        uint256 mintAmount
    ) ERC20(name, symbol) {
        _mint(msg.sender, mintAmount);
    }
}
