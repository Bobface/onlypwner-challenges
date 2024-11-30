pragma solidity =0.8.19;

import {UserOracle} from "../src/UserOracle.sol";
import {MultiSourceOracle} from "../src/MultiSourceOracle.sol";

contract OneFeed {
    fallback() external {
        UserOracle(msg.sender).feedCallback(address(0x1234), 10 ** 18);
    }
}

contract DummyUser {
    constructor(MultiSourceOracle oracle) payable {
        address feed = address(new OneFeed());
        oracle.deposit{value: 1 ether}();
        oracle.deployUserOracle(feed, new uint24[](0));
    }
}
