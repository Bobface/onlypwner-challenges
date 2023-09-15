pragma solidity ^0.8.20;

import {ITarget} from "./interfaces/ITarget.sol";
import {IStunt} from "./interfaces/IStunt.sol";

contract Stunt is IStunt {
    address public override owner;
    mapping(address => bool) public override solved;
    mapping(address => bool) public override claimed;

    constructor() payable {
        owner = msg.sender;
    }

    modifier onlyContract(address target) {
        uint256 size;
        assembly {
            size := extcodesize(target)
        }

        require(size > 0, "not a contract");
        _;
    }

    function attempt(address target) external override onlyContract(target) {
        bytes32 firstResult = ITarget(target).first();
        require(firstResult == hex"deadbeef", "first failed");

        bytes32 secondResult = ITarget(target).second();
        require(secondResult == hex"c0ffeebabe", "second failed");

        bytes32 thirdResult = ITarget(target).third();
        require(thirdResult == hex"1337", "third failed");

        solved[target] = true;
    }

    function claimReward(
        address target
    ) external override onlyContract(target) {
        require(solved[target], "not solved");
        require(!claimed[target], "already claimed");

        claimed[target] = true;

        uint256 size;
        assembly {
            size := extcodesize(target)
        }

        uint256 reward;
        if (size <= 3) {
            // Don't worry, that is impossible.
            reward = 100 ether;
        } else if (size <= 10) {
            reward = 1e12;
        } else if (size <= 100) {
            reward = 1e10;
        }

        (bool success, ) = target.call{value: reward}("");
        require(success, "transfer failed");
    }

    function withdraw() external override {
        require(msg.sender == owner, "not owner");
        payable(msg.sender).transfer(address(this).balance);
    }
}
