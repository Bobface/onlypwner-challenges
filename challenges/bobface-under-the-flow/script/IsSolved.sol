pragma solidity ^0.7.0;

import {ImprovedERC20} from "../src/ImprovedERC20.sol";
import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";

contract IsSolved is Script {
    function run() external view {
        ImprovedERC20 erc20 = ImprovedERC20(vm.envAddress("ImprovedERC20"));
        address user = vm.envAddress("USER");

        if (erc20.balanceOf(user) > 0) {
            console.log("is-solved:true");
        } else {
            console.log("is-solved:false");
        }
    }
}
