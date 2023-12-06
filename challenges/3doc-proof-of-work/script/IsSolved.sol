pragma solidity 0.8.21;

import {DarkToken} from "../src/DarkToken.sol";

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract IsSolved is Script {
    function run() external view {
        address user = vm.envAddress("USER");
        DarkToken dt = DarkToken(vm.envAddress("DRK"));

        if (dt.balanceOf(user) >= 10 ether) {
            console.log("is-solved:true");
        } else {
            console.log("is-solved:false");
        }
    }
}
