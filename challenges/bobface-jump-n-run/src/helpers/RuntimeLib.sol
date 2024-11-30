// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.19;
import "./BytesLib.sol";

library RuntimeLib {
    function deploy(bytes memory code) internal returns (address) {
        // Prepends a minimal constructor to save some gas
        bytes memory initcode = getInitCode(code);
        address addr;
        assembly {
            addr := create(0, add(initcode, 0x20), mload(initcode))
        }

        require(addr != address(0), "failed to deploy contract");

        return addr;
    }

    function getInitCode(
        bytes memory code
    ) private pure returns (bytes memory) {
        // PUSH size, offset, destoffset; CODECOPY; PUSH size, offset; RETURN;
        bytes memory init = hex"610000600E6000396100006000F3";
        //                        ----            ----
        // Set the size of the runtime bytecode
        uint256 len = code.length;
        assembly {
            let lowerByte := and(0xff, len)
            let upperByte := shr(8, len)

            mstore8(add(init, 0x21), upperByte)
            mstore8(add(init, 0x22), lowerByte)

            mstore8(add(init, 0x29), upperByte)
            mstore8(add(init, 0x2A), lowerByte)
        }

        return BytesLib.concat(init, code);
    }
}
