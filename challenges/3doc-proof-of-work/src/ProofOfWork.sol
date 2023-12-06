pragma solidity 0.8.21;

import {IDireOwner} from "./interfaces/IDireOwner.sol";
import {IProofOfWork} from "./interfaces/IProofOfWork.sol";

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";

contract ProofOfWork is IProofOfWork, Ownable {

    IERC20 immutable public darkToken;
    uint256 immutable public assignmentDuration;

    uint256 private difficulty;
    uint256 private minimumDarkness;
    mapping(address => Assignment) assignment;

    struct Assignment {
        uint256 deadline;
        uint256 challenge;
        uint256 difficulty;
        uint256 bet;
    }

    constructor(IERC20 darkToken_, 
        uint256 assignmentDuration_,
        uint256 protectedSupply
    ) Ownable(msg.sender) {
        darkToken = darkToken_;
        assignmentDuration = assignmentDuration_;

        difficulty = uint256(type(uint64).max);
    }

    function withdraw(uint256 amount) external override onlyOwner {
        darkToken.transfer(msg.sender, amount);

        require(darkToken.balanceOf(address(this)) >= minimumDarkness);
    }

    function submitAssignment(address newOwner, uint256 referralCode) external override {
        Assignment memory newAssignment;

        newAssignment.challenge = uint256(blockhash(block.number - 1));
        newAssignment.difficulty = difficulty;
        newAssignment.deadline = block.timestamp + assignmentDuration;

        assignment[newOwner] = newAssignment;

        // it's OK if difficulty overflows: it is meant to be capped to type(uint256).max
        unchecked {
            difficulty = difficulty << 1;
            difficulty += 1;
        }

        // want dark coins? got some direly hard work in my TODO list - help me with it
        uint256 bet = IDireOwner(newOwner).workMyDirefulOwner(
            referralCode,
            newAssignment.challenge & newAssignment.difficulty
        );

        require(bet > 0);

        // extra points if you can solve TWO problems
        assignment[newOwner].bet = bet;
    }

    function checkAssignment(address newOwner) external override {
        // should submit on time
        require(block.timestamp < assignment[newOwner].deadline);

        // should submit right
        uint256 proof = IDireOwner(newOwner).proofOfDreadfulWork();
        require(
            uint256(keccak256(
                abi.encode(assignment[newOwner].challenge, proof))) 
            & assignment[newOwner].difficulty == 0
        );

        // extra points if you guessed most bits immediately
        uint256 guessedBits = proof ^ assignment[newOwner].bet;
        uint256 count;
        
        for (uint256 i = 0; i < 256; i++) {
            // Check if the i-th bit is 0
            if ((guessedBits & (1 << i)) == 0) {
                count++;
            }
        }

        if(count >= 192) minimumDarkness /= 2;
        
        delete assignment[newOwner];

        // well done, we are friends now
        _transferOwnership(newOwner);
    }
}
