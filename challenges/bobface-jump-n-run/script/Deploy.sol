pragma solidity =0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {UserOracle} from "../src/UserOracle.sol";
import {MultiSourceOracle} from "../src/MultiSourceOracle.sol";

import {DummyUser} from "./DummyUser.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy oracle
        address userOracleTemplate = address(new UserOracle());
        MultiSourceOracle oracle = new MultiSourceOracle(
            address(0x1234),
            userOracleTemplate
        );

        // Setup dummy users
        for (uint256 i = 0; i < 3; i++) {
            DummyUser dummyUser = new DummyUser{value: 1 ether}(oracle);
        }

        // Fund the user
        address user = vm.envAddress("USER");
        payable(user).transfer(50 ether);

        console.log("address:Oracle", address(oracle));
    }
}
