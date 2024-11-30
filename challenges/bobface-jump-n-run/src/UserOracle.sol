// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.19;

import "./interfaces/IUserOracle.sol";

// This contract serves as a caching layer between the Oracle and the Feeds.
contract UserOracle is IUserOracle {
    // The asset the oracle is reporting the price on (in USD)
    address private asset;

    // The feed that supplies the price.
    // Since any feed can be used, including user supplied ones, these are considered untrusted.
    address private feed;

    // The last time the price was updated.
    // Limited to 60s to save gas.
    uint256 private lastUpdate;

    // The latest price of the asset in USD.
    uint256 private price;

    function initialize(address _asset, address _feed) external {
        require(asset == address(0), "already initialized");
        require(_asset != address(0), "invalid asset");
        require(_feed != address(0), "invalid feed");
        asset = _asset;
        feed = _feed;
    }

    // Update the price if it is older than 60s.
    // Feed will call feedCallback() from it's fallback function to update the price.
    function update() external {
        uint256 age = block.timestamp - getLastUpdate();
        address feedAddr = getFeed();
        assembly {
            if gt(age, 60) {
                let result := call(gas(), feedAddr, 0, 0, 0, 0, 0)
                if iszero(result) {
                    revert(0, 0)
                }
            }
        }
    }

    // Callback by a feed to update the price.
    // Feeds can decide to update by themselves without a prior call to forceUpdate.
    function feedCallback(address _asset, uint256 _price) external {
        require(msgSender() == getFeed(), "invalid sender");
        require(getAsset() == _asset, "invalid asset");
        lastUpdate = block.timestamp;
        price = _price;
    }

    function getAsset() public view returns (address) {
        return asset;
    }

    function getFeed() public view returns (address) {
        return feed;
    }

    function getPrice() public view returns (uint256) {
        return price;
    }

    function getLastUpdate() public view returns (uint256) {
        return lastUpdate;
    }

    function msgSender() public view returns (address) {
        return msg.sender;
    }
}
