pragma solidity ^0.8.20;

import {Vault} from "../src/Vault.sol";
import {MintableERC20} from "../src/MintableERC20.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        MintableERC20 token = new MintableERC20("TOKEN", "TOKEN", 10 ether);
        Vault vault = new Vault(address(token));

        address user = vm.envAddress("USER");
        token.transfer(user, 9 ether);

        console.log("address:Token", address(token));
        console.log("address:Vault", address(vault));
    }
}
