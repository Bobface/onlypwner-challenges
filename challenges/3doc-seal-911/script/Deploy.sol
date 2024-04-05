pragma solidity 0.8.21;

import {Vault} from "../src/Vault.sol";

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        address user = vm.envAddress("USER");
        address safeAddress = address(
            uint160(uint256(keccak256("this is safe!")))
        );
        uint256 supply = 100 ether;

        Vault vault = new Vault(user);
        (bool ok, ) = address(vault).call{value: supply}("");
        if (!ok) {
            // This should never happen, but just in case
            revert("Failed to send funds to vault");
        }

        console.log("address:Vault", address(vault));
        console.log("address:SAFE", address(safeAddress));
    }
}
