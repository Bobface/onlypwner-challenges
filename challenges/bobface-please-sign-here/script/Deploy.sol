pragma solidity 0.8.19;

import {Petition} from "../src/Petition.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        Petition petition = new Petition();
        petition.initialize();

        console.log("address:Petition", address(petition));
    }
}
