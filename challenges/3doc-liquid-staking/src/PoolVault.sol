pragma solidity ^0.8.20;

import {IPoolVault} from "./interfaces/IPoolVault.sol";
import {SafeTransferLib} from "lib/solady/src/utils/SafeTransferLib.sol";

contract PoolVault is IPoolVault {
    using SafeTransferLib for address;

    mapping(address synthetic => mapping (address owner => uint)) public balance;

    function depositFor(address synthetic, address beneficiary, uint amount) external {
        synthetic.safeTransferFrom(msg.sender, address(this), amount);
        balance[synthetic][beneficiary] += amount;
    }

    function withdraw(address synthetic, uint amount) external {
        balance[synthetic][msg.sender] -= amount;
        synthetic.safeTransfer(msg.sender, amount);
    }
}
