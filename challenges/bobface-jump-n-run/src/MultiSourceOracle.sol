// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.19;

import "./UserOracle.sol";
import "./helpers/UserLib.sol";
import "./interfaces/IMultiSourceOracle.sol";

contract MultiSourceOracle is IMultiSourceOracle {
    using UserLib for UserLib.UserData;

    // The collateral required to run an oracle.
    uint256 public constant override MIN_COLLATERAL = 1 ether;

    // The maximum number of users that can be registered.
    // This might be increased in the future.
    uint16 public override MAX_USERS = 100;

    // The address of the asset for that the oracle is reporting the price.
    address public immutable override asset;

    // The price of the asset in USD.
    uint256 public override price;

    // The timestamp of the last price update.
    uint256 public override timestamp;

    address public override userOracleTemplate;

    // Price update lock
    bool private inPriceUpdate;

    // User data
    mapping(address => UserLib.UserData) public users;
    address[] public userList;

    constructor(address _asset, address _template) {
        asset = _asset;
        userOracleTemplate = _template;
    }

    // ====================================================================
    // === PRICE UPDATE

    modifier priceUpdate() {
        require(!inPriceUpdate, "price update in progress");
        inPriceUpdate = true;
        _;
        inPriceUpdate = false;
    }

    modifier notWhilePriceUpdate() {
        require(!inPriceUpdate, "price update in progress");
        _;
    }

    function updatePrice() external override priceUpdate {
        uint256 summedPrices;
        uint256 numPrices;

        for (uint256 i = 0; i < userList.length; i++) {
            address userAddr = userList[i];
            UserLib.UserData storage user = users[userAddr];
            if (user.oracle == address(0)) {
                // User has no oracle (yet), skip.
                continue;
            }

            try this.updateUserOraclePrice(userAddr) returns (
                uint256 userPrice
            ) {
                summedPrices += userPrice;
                numPrices++;
            } catch {
                // TODO: Should we penalize the user?
                // Maybe something for V2.
            }
        }

        if (numPrices == 0) {
            return;
        }

        price = summedPrices / numPrices;
        timestamp = block.timestamp;
    }

    function updateUserOraclePrice(
        address userAddr
    ) external override returns (uint256) {
        UserLib.UserData storage user = users[userAddr];
        UserOracle(user.oracle).update();
        return UserOracle(user.oracle).getPrice();
    }

    // ====================================================================
    // === USER ORACLE & COLLATERAL MANAGEMENT

    function deposit() external payable override {
        UserLib.UserData storage user = users[msg.sender];
        if (!user.exists()) {
            require(userList.length != MAX_USERS, "max users reached");
            userList.push(msg.sender);
            user.initialize(uint16(userList.length), uint16(userList.length));
        }

        user.increaseCollateralUnchecked(msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function deployUserOracle(
        address feed,
        uint24[] memory newDiscounts
    ) external override notWhilePriceUpdate {
        UserLib.UserData storage user = users[msg.sender];
        bytes memory discounts = user.getDiscounts();

        require(user.exists(), "user not registered");
        require(!user.hasOracle(), "oracle already exists");

        bytes memory code = userOracleTemplate.code;
        require(code.length > 0, "no code");

        require(
            user.freeCollateral >= MIN_COLLATERAL,
            "insufficient collateral"
        );

        if (newDiscounts.length > 0) {
            require(
                newDiscounts.length <= userList.length,
                "too many discounts"
            );
            user.updateDiscounts(newDiscounts, discounts);
        }

        user.deployOracle(code);
        UserOracle(user.oracle).initialize(asset, feed);
        // We verified collateral >= MIN_COLLATERAL before
        user.decreaseCollateralUnchecked(MIN_COLLATERAL);

        emit SetupUserOracle(msg.sender, user.oracle);
    }

    function withdraw(uint256 amount) external override notWhilePriceUpdate {
        UserLib.UserData storage user = users[msg.sender];
        require(user.freeCollateral >= amount, "insufficient funds");
        // See check above
        user.decreaseCollateralUnchecked(amount);

        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    function shutdownUserOracle() external override notWhilePriceUpdate {
        UserLib.UserData storage user = users[msg.sender];
        require(user.hasOracle(), "no oracle");

        emit ShutdownUserOracle(msg.sender, user.oracle);

        user.increaseCollateralUnchecked(MIN_COLLATERAL);
        user.oracle = address(0);
    }

    function collateral(
        address userAddr
    ) external view override returns (uint256) {
        return users[userAddr].freeCollateral;
    }
}
