pragma solidity 0.8.21;

import {PoolVault} from "src/PoolVault.sol";
import {SyntheticTokenFactory} from "src/SyntheticTokenFactory.sol";

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        address user = vm.envAddress("USER");

        vm.startBroadcast();
        user.call{value: 100 ether}("");

        PoolVault pv = new PoolVault();
        SyntheticTokenFactory stf = new SyntheticTokenFactory(address(this), pv);

        console.log("address:PoolVault", address(pv));
        console.log("address:SyntheticTokenFactory", address(stf));

        vm.stopBroadcast();
    }
}
