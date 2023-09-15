pragma solidity ^0.8.20;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

interface IVault {
    function deposit(uint256 amount) external;

    function withdraw(uint256 sharesAmount) external;

    function owner() external view returns (address);

    function token() external view returns (IERC20);

    function shares(address) external view returns (uint256);

    function totalShares() external view returns (uint256);
}
