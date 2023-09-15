pragma solidity ^0.8.20;

import {Bridge} from "../src/Bridge.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        address user = vm.envAddress("USER");
        Bridge bridge = new Bridge();

        payable(user).transfer(1 ether);
        bridge.registerValidator{value: 100 ether}(address(0), "Some Tag");

        console.log("address:Bridge", address(bridge));
    }
}
