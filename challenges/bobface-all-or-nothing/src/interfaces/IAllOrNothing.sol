pragma solidity 0.8.20;

interface IAllOrNothing {
    function declareWinner(address user) external;

    function withdrawWinnings() external;

    function bet(uint256 number, address recipient) external payable;

    function void() external;

    function transfer(address to) external;

    function publish(uint256 number) external;

    function owner() external returns (address);

    function bestPlayer() external returns (address);

    function winningNumber() external returns (uint256);

    function bets(address) external returns (uint256);

    function BET_AMOUNT() external returns (uint256);

    function DEADLINE() external returns (uint256);

    function DECLARE_DEADLINE() external returns (uint256);
}
