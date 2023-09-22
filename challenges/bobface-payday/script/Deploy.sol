pragma solidity 0.8.20;

import {Distributor} from "../src/Distributor.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        bytes32 root = 0x0c84a3e9e1a4e96e87bb78fd998f408ffa450e6248b880f69fcd6c7c38dee4dc;
        uint256 amount = 12.1 ether;
        Distributor distributor = new Distributor{value: amount}(root);

        console.log("address:Distributor", address(distributor));
    }
}
