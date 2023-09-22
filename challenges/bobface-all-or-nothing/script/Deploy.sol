pragma solidity 0.8.20;

import {AllOrNothing} from "../src/AllOrNothing.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        address user = vm.envAddress("USER");
        AllOrNothing allOrNothing = new AllOrNothing(1 ether, 10 minutes);

        allOrNothing.bet{value: 1 ether}(1, address(uint160(user) + 1));
        allOrNothing.bet{value: 1 ether}(1, address(uint160(user) + 2));
        allOrNothing.bet{value: 1 ether}(1, address(uint160(user) + 3));
        allOrNothing.bet{value: 1 ether}(1, address(uint160(user) + 4));
        allOrNothing.bet{value: 1 ether}(1, address(uint160(user) + 5));

        payable(user).transfer(1 ether);

        console.log("address:AllOrNothing", address(allOrNothing));
    }
}
