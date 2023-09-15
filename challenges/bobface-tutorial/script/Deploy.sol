pragma solidity 0.8.19;

import {Tutorial} from "../src/Tutorial.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        Tutorial tutorial = new Tutorial{value: 10 ether}();

        console.log("address:Tutorial", address(tutorial));
    }
}
