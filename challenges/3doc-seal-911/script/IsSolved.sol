pragma solidity 0.8.21;

import {Vault} from "../src/Vault.sol";

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract IsSolved is Script {
    function run() external view {
        address safe = vm.envAddress("SAFE");

        if (vault.balanceOf(safe) == 100 ether) {
            console.log("is-solved:true");
        } else {
            console.log("is-solved:false");
        }
    }
}
