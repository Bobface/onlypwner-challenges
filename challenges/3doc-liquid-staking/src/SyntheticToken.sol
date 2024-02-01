pragma solidity ^0.8.20;

import {ISyntheticTokenFactory} from "./interfaces/ISyntheticTokenFactory.sol";

import {ERC20} from "lib/solady/src/tokens/ERC20.sol";
import {LibString} from "lib/solady/src/utils/LibString.sol";

contract SyntheticToken is ERC20 {
    string private NAME;
    string private SYMBOL;

    address public factory;

    constructor(uint sequence, uint initialSupply) {
        NAME = LibString.concat("Synthetic #", LibString.toString(sequence));
        SYMBOL = LibString.concat("SYN#", LibString.toString(sequence));

        factory = msg.sender;
        _mint(factory, initialSupply);
    }

    function name() public view override returns (string memory) {
        return NAME;
    }

    function symbol() public view override returns (string memory) {
        return SYMBOL;
    }

    function burn(address from, uint amount) external {
        require(msg.sender == factory);
        _burn(from, amount);
    }
}
