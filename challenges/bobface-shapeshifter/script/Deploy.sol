pragma solidity ^0.8.20;

import {Stunt} from "../src/Stunt.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        Stunt stunt = new Stunt{value: 101 ether}();

        console.log("address:Stunt", address(stunt));
    }
}
