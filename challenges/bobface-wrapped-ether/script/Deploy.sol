pragma solidity 0.8.20;

import {WrappedEther} from "../src/WrappedEther.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        address user = vm.envAddress("USER");
        WrappedEther weth = new WrappedEther();

        weth.deposit{value: 1 ether}(address(uint160(user) + 1));
        weth.deposit{value: 1 ether}(address(uint160(user) + 2));
        weth.deposit{value: 1 ether}(address(uint160(user) + 3));
        weth.deposit{value: 1 ether}(address(uint160(user) + 4));
        weth.deposit{value: 1 ether}(address(uint160(user) + 5));

        payable(user).transfer(1 ether);

        console.log("address:WrappedEther", address(weth));
    }
}
