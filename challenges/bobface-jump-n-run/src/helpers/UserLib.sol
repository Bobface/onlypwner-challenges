// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.19;

import "./RuntimeLib.sol";

// Manages user data:
// collateral, oracle, price query discounts for other users (TBD in V2)
library UserLib {
    struct UserData {
        // Will never have more than 2^16 users
        uint16 id;
        // Collateral gets locked when the user deploys an oracle
        uint256 freeCollateral;
        address oracle;
        // 3 bytes per user: discount percentage (1 byte), discounted user ID (2 bytes)
        bytes discounts;
    }

    function initialize(
        UserData storage user,
        uint16 id,
        uint16 numUsers
    ) internal {
        user.id = id;
        user.discounts = new bytes(numUsers * 3);
    }

    function increaseCollateralUnchecked(
        UserData storage user,
        uint256 amount
    ) internal {
        // Won't overflow.
        unchecked {
            user.freeCollateral += amount;
        }
    }

    function decreaseCollateral(
        UserData storage user,
        uint256 amount
    ) internal {
        user.freeCollateral -= amount;
    }

    function decreaseCollateralUnchecked(
        UserData storage user,
        uint256 amount
    ) internal {
        // Validate before calling!
        unchecked {
            user.freeCollateral -= amount;
        }
    }

    function updateDiscounts(
        UserData storage user,
        uint24[] memory discounts,
        bytes memory discountsData
    ) internal {
        for (uint256 i = 0; i < discounts.length; i++) {
            uint24 discount = discounts[i];
            require(isAllowedDiscount(discount), "invalid discount");
            assembly {
                let data := add(discountsData, 0x20)
                let off := mul(i, 3)
                mstore8(add(data, off), shr(16, discount))
                mstore8(add(data, add(off, 1)), shr(8, discount))
                mstore8(add(data, add(off, 2)), discount)
            }
        }

        user.discounts = discountsData;
    }

    function getDiscounts(
        UserData storage user
    ) internal view returns (bytes memory) {
        return user.discounts;
    }

    function hasOracle(UserData storage user) internal view returns (bool) {
        return user.oracle != address(0);
    }

    function deployOracle(UserData storage user, bytes memory code) internal {
        user.oracle = RuntimeLib.deploy(code);
    }

    function exists(UserData storage user) internal view returns (bool) {
        return user.id != 0;
    }

    function isAllowedDiscount(uint24 discount) internal pure returns (bool) {
        // Only free access (0) or 3% discount (97) are allowed for now
        uint24 discountValue = discount >> 16;
        return discountValue == 0 || discountValue == 97;
    }
}
