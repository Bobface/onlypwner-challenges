pragma solidity =0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract IsSolved is Script {
    function run() external view {
        address user = vm.envAddress("USER");

        if (address(user).balance > 50 ether) {
            console.log("is-solved:true");
        } else {
            console.log("is-solved:false");
        }
    }
}
