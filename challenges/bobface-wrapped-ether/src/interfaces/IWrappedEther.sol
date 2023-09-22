pragma solidity 0.8.20;

interface IWrappedEther {
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );
    event Deposit(address indexed from, uint256 amount);
    event Withdraw(address indexed to, uint256 amount);

    function deposit(address to) external payable;

    function withdraw(uint256 amount) external;

    function withdrawAll() external;

    function transfer(address to, uint256 amount) external;

    function transferFrom(address from, address to, uint256 amount) external;

    function approve(address spender, uint256 amount) external;

    function balanceOf(address account) external view returns (uint256);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);
}
