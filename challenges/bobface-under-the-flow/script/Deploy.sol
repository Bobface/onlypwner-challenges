pragma solidity ^0.7.0;

import {ImprovedERC20} from "../src/ImprovedERC20.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        ImprovedERC20 erc20 = new ImprovedERC20(
            "Improved ERC20",
            "IMPERC20",
            18,
            100 ether
        );

        address otherUser = address(uint160(vm.envAddress("USER")) + 1);
        erc20.transfer(otherUser, 100 ether);

        console.log("address:ImprovedERC20", address(erc20));
        console.log("address:Other_User", address(otherUser));
    }
}
