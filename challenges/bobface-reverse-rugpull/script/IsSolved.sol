pragma solidity ^0.8.20;

import {Vault} from "../src/Vault.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";

contract IsSolved is Script {
    function run() external {
        vm.startBroadcast();

        IERC20 token = IERC20(vm.envAddress("Token"));
        Vault vault = Vault(vm.envAddress("Vault"));
        address scripter = vm.envAddress("SCRIPTER");

        if (token.balanceOf(address(vault)) < 1 ether) {
            console.log("is-solved:false");
            return;
        }

        token.approve(address(vault), 10 ** 17);
        vault.deposit(10 ** 17);

        uint256 shares = vault.shares(scripter);
        if (shares == 0) {
            console.log("is-solved:true");
        } else {
            console.log("is-solved:false");
        }
    }
}
