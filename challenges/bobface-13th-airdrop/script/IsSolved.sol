pragma solidity =0.8.13;

import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";

contract IsSolved is Script {
    function run() external view {
        address airdrop = vm.envAddress("Airdrop");

        if (airdrop.balance <= 30 ether) {
            console.log("is-solved:true");
        } else {
            console.log("is-solved:false");
        }
    }
}
