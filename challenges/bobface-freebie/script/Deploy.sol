pragma solidity 0.8.19;

import {Vault} from "../src/Vault.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        Vault vault = new Vault();
        vault.deposit{value: 10 ether}();

        console.log("address:Vault", address(vault));
    }
}
