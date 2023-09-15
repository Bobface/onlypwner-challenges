pragma solidity ^0.8.20;

interface IOracle {
    function owner() external view returns (address);

    function vulToWethPrice() external view returns (uint256);

    function setVulToWethPrice(uint256 _vulPriceInEth) external;
}
