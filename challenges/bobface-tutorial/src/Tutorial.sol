pragma solidity 0.8.19;

import {ITutorial} from "./interfaces/ITutorial.sol";

contract Tutorial is ITutorial {
    constructor() payable {}

    function callMe() external override {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Tutorial: call failed");
    }
}
