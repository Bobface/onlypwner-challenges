// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.19;

interface IMultiSourceOracle {
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event SetupUserOracle(address indexed user, address oracle);
    event ShutdownUserOracle(address indexed user, address oracle);

    function updatePrice() external;
    function updateUserOraclePrice(address userAddr) external returns (uint256);

    function deposit() external payable;
    function deployUserOracle(address feed, uint24[] memory discounts) external;
    function withdraw(uint256 amount) external;
    function shutdownUserOracle() external;

    function MIN_COLLATERAL() external view returns (uint256);
    function MAX_USERS() external view returns (uint16);
    function asset() external view returns (address);
    function price() external view returns (uint256);
    function timestamp() external view returns (uint256);
    function userList(uint256 index) external view returns (address);
    function userOracleTemplate() external view returns (address);
    function collateral(address userAddr) external view returns (uint256);
}
