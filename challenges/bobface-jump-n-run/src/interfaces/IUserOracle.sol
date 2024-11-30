// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.19;

interface IUserOracle {
    function initialize(address _asset, address _feed) external;
    function update() external;
    function feedCallback(address _asset, uint256 _price) external;

    function getAsset() external view returns (address);
    function getFeed() external view returns (address);
    function getPrice() external view returns (uint256);
    function getLastUpdate() external view returns (uint256);
    function msgSender() external view returns (address);
}
