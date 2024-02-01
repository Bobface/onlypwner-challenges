pragma solidity 0.8.21;

import {ISyntheticTokenFactory} from "../src/interfaces/ISyntheticTokenFactory.sol";

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract IsSolved is Script {
    function run() external view {
        ISyntheticTokenFactory stf = ISyntheticTokenFactory(vm.envAddress("SyntheticTokenFactory"));
        address user = vm.envAddress("USER");

        if (stf.syntheticsLength() == 0 || user.balance < 100 ether) {
            console.log("is-solved:false");
            return;
        }

        console.log("is-solved:true");
    }
}
