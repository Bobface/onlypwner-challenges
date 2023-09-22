pragma solidity 0.8.20;

import {IAllOrNothing} from "./interfaces/IAllOrNothing.sol";
import {Multicall} from "./Multicall.sol";

/// A contract where users can bet on a random number being published.
/// The user who is closest to the number wins all the bets.
contract AllOrNothing is IAllOrNothing, Multicall {
    address public owner;
    address public bestPlayer;
    uint256 public winningNumber;
    mapping(address => uint256) public bets;

    uint256 public immutable BET_AMOUNT;
    uint256 public immutable DEADLINE;
    uint256 public immutable DECLARE_DEADLINE;

    constructor(uint256 betAmount, uint256 duration) {
        owner = msg.sender;
        BET_AMOUNT = betAmount;
        DEADLINE = block.timestamp + duration;
        DECLARE_DEADLINE = DEADLINE + 1 days;
    }

    function declareWinner(address user) external {
        require(bets[user] != 0, "Must have placed bet");
        require(
            block.timestamp >= DEADLINE && block.timestamp < DECLARE_DEADLINE,
            "Deadline not passed"
        );
        require(winningNumber != 0, "Winning number not published");

        if (bestPlayer == address(0)) {
            bestPlayer = user;
            return;
        }

        unchecked {
            uint256 distance = bets[user] > winningNumber
                ? bets[user] - winningNumber
                : winningNumber - bets[user];

            uint256 bestDistance = bets[bestPlayer] > winningNumber
                ? bets[bestPlayer] - winningNumber
                : winningNumber - bets[bestPlayer];

            if (distance < bestDistance) {
                bestPlayer = user;
            }
        }
    }

    function withdrawWinnings() external {
        require(msg.sender == bestPlayer, "Must be best player");
        require(block.timestamp >= DECLARE_DEADLINE, "Deadline not passed");

        payable(msg.sender).transfer(address(this).balance);
    }

    function bet(uint256 number, address recipient) external payable {
        require(bets[recipient] == 0, "Already placed bet");
        require(msg.value == BET_AMOUNT, "Value too low");
        require(block.timestamp < DEADLINE, "Deadline passed");

        bets[recipient] = number;
    }

    function void() external {
        require(bets[msg.sender] != 0, "Must have placed bet");
        require(block.timestamp < DEADLINE, "Deadline passed");

        bets[msg.sender] = 0;
        payable(msg.sender).transfer(BET_AMOUNT);
    }

    function transfer(address to) external {
        require(bets[msg.sender] != 0, "Must have placed bet");
        require(bets[to] == 0, "Recipient must not have placed bet");

        bets[to] = bets[msg.sender];
        bets[msg.sender] = 0;
    }

    function publish(uint256 number) external {
        require(msg.sender == owner, "Must be owner");
        require(block.timestamp >= DEADLINE, "Deadline not passed");

        winningNumber = number;
    }
}
