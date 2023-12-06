pragma solidity 0.8.21;

import {DarkToken} from "../src/DarkToken.sol";
import {ProofOfWork} from "../src/ProofOfWork.sol";

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        uint256 supply = 20 ether;

        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);

        DarkToken dt = new DarkToken("Dark Token", "DRK", supply);
        ProofOfWork pow = new ProofOfWork(dt, 5 minutes, 15 ether);

        dt.transfer(address(pow), supply);

        console.log("address:DRK", address(dt));
        console.log("address:ProofOfWork", address(pow));
    }
}