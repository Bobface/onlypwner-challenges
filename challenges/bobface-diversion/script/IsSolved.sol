pragma solidity ^0.8.20;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";

contract IsSolved is Script {
    function run() external view {
        IERC20 WETH = IERC20(vm.envAddress("WETH"));
        address user = vm.envAddress("USER");

        if (WETH.balanceOf(user) > 20 ether) {
            console.log("is-solved:true");
        } else {
            console.log("is-solved:false");
        }
    }
}
