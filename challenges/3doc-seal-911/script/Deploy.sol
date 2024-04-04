pragma solidity 0.8.21;

import {Vault} from "../src/DarkToken.sol";

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        address user = vm.envAddress("USER");
        uint256 supply = 100 ether;

        vm.startBroadcast();
        Vault vault = new Vault(user);
        dt.transfer(address(vault), supply);

        console.log("address:Vault", address(vault));
    }
}
