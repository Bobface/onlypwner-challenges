pragma solidity 0.8.19;

import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";

contract IsSolved is Script {
    function run() external view {
        address tutorial = vm.envAddress("Tutorial");

        if (tutorial.balance == 0) {
            console.log("is-solved:true");
        } else {
            console.log("is-solved:false");
        }
    }
}
