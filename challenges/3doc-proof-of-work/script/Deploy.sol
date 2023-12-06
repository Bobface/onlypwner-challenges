pragma solidity 0.8.21;

import {DarkToken} from "../src/DarkToken.sol";
import {ProofOfWork} from "../src/ProofOfWork.sol";

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        uint256 supply = 20 ether;
        DarkToken dt = new DarkToken("Dark Token", "DRK", supply);
        ProofOfWork pow = new ProofOfWork(dt, 1 minutes, 15 ether);

        dt.transfer(address(pow), supply);

        console.log("address:DRK", address(dt));
        console.log("address:ProofOfWork", address(pow));
    }
}
