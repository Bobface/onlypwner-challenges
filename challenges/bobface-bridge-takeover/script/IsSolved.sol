pragma solidity ^0.8.20;

import {Bridge} from "../src/Bridge.sol";
import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";

contract IsSolved is Script {
    function run() external view {
        Bridge bridge = Bridge(vm.envAddress("Bridge"));

        if (bridge.stateRoot() == bytes32(uint256(0xdeadbeef))) {
            console.log("is-solved:true");
        } else {
            console.log("is-solved:false");
        }
    }
}
