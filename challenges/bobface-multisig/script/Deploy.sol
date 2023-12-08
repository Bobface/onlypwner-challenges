pragma solidity 0.8.20;

import {Multisig} from "../src/Multisig.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        address[] memory owners = new address[](5);
        owners[0] = vm.envAddress("USER");
        owners[1] = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
        owners[2] = 0xBE0eB53F46cd790Cd13851d5EFf43D12404d33E8;
        owners[3] = 0xDA9dfA130Df4dE4673b89022EE50ff26f6EA73Cf;
        owners[4] = 0xF977814e90dA44bFA03b6295A0616a897441aceC;

        Multisig multisig = new Multisig(owners, 3);
        payable(multisig).transfer(100 ether);

        console.log("address:Multisig", address(multisig));
    }
}
