pragma solidity 0.8.20;

import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";

contract IsSolved is Script {
    function run() external view {
        address weth = vm.envAddress("WrappedEther");

        if (weth.balance == 0) {
            console.log("is-solved:true");
        } else {
            console.log("is-solved:false");
        }
    }
}
