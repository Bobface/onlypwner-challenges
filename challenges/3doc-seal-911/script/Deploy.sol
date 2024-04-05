pragma solidity 0.8.21;

import {Vault} from "../src/Vault.sol";

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        address user = vm.envAddress("USER");
        address safeAddress = address(uint160(uint256(keccak256("this is safe!"))));
        uint256 supply = 100 ether;

        vm.startBroadcast();
        Vault vault = new Vault(user);
        address(vault).call{value: supply}("");

        console.log("address:Vault", address(vault));
        console.log("address:SAFE", address(safeAddress));
    }
}
