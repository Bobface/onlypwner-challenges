pragma solidity 0.8.19;

import {Petition} from "../src/Petition.sol";
import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";

contract IsSolved is Script {
    function run() external view {
        Petition petition = Petition(vm.envAddress("Petition"));

        if (petition.isFinished()) {
            console.log("is-solved:true");
        } else {
            console.log("is-solved:false");
        }
    }
}
