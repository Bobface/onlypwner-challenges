pragma solidity 0.8.21;

import {Vault} from "../src/Vault.sol";

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract IsSolved is Script {
    function run() external view {
        address user = vm.envAddress("USER");
        Vault vault = Vault(vm.envAddress("Vault"));

        if (vault.balanceOf(user) == 0 && 
            address(vault).balance == 0 && 
            user.balance == 0) {
            console.log("is-solved:true");
        } else {
            console.log("is-solved:false");
        }
    }
}
