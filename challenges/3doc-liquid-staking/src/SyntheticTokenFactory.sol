pragma solidity 0.8.21;

import {IPoolVault} from "./interfaces/IPoolVault.sol";
import {ISyntheticTokenFactory} from "./interfaces/ISyntheticTokenFactory.sol";

import {SyntheticToken} from "./SyntheticToken.sol";

import {ERC20} from "lib/solady/src/tokens/ERC20.sol";
import {LibString} from "lib/solady/src/utils/LibString.sol";
import {SafeTransferLib} from "lib/solady/src/utils/SafeTransferLib.sol";

contract SyntheticTokenFactory is ISyntheticTokenFactory {
    uint public currentSequence;
    uint public mintedSupply;

    address public feeReceiver;
    IPoolVault public poolVault;

    mapping(address => bool) public isActive;
    address[] public synthetics;

    constructor(address _feeReceiver, IPoolVault _vault) {
        feeReceiver = _feeReceiver;
        poolVault = _vault;
    }

    function syntheticsLength() external view returns(uint) {
        return synthetics.length;
    }

    function createSynthetic() external payable returns (address) {
        require(msg.value >= 1 ether, "STF: No native tokens provided");

        SyntheticToken st = new SyntheticToken(++currentSequence, msg.value);

        mintedSupply += msg.value;
        isActive[address(st)] = true;
        synthetics.push(address(st));

        uint feeAmt = msg.value / 10;

        st.approve(address(poolVault), feeAmt);
        poolVault.depositFor(address(st), feeReceiver, feeAmt);

        st.transfer(msg.sender, msg.value - feeAmt);
        return address(st);
    }

    function redeemTokens(address synthetic, uint amount) external {
        require(isActive[synthetic], "STF: Not a synthetic");
        SyntheticToken st = SyntheticToken(synthetic);

        st.burn(msg.sender, amount);
        if(st.totalSupply() == 0){
            isActive[synthetic] = false;
        }

        mintedSupply -= amount;
        SafeTransferLib.safeTransferETH(msg.sender, amount);
    }
}
