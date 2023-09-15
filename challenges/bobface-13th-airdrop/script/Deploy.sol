pragma solidity =0.8.13;

import {Airdrop} from "../src/Airdrop.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        address user = vm.envAddress("USER");

        Airdrop airdrop = new Airdrop();
        airdrop.addRecipient{value: 10 ether}(user);
        airdrop.addRecipient{value: 10 ether}(address(uint160(user) + 1));
        airdrop.addRecipient{value: 10 ether}(address(uint160(user) + 2));
        airdrop.addRecipient{value: 10 ether}(address(uint160(user) + 3));
        airdrop.addRecipient{value: 10 ether}(address(uint160(user) + 4));
        airdrop.addRecipient{value: 10 ether}(address(uint160(user) + 5));

        console.log("address:Airdrop", address(airdrop));
    }
}
