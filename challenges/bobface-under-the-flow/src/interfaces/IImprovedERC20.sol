pragma solidity ^0.7.0;

interface IImprovedERC20 {
    function transfer(address _to, uint256 _value) external returns (bool);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool);

    function approve(address _spender, uint256 _value) external returns (bool);

    function mint(uint256 _value) external;

    function burn(address _who, uint256 _value) external;

    function owner() external view returns (address);

    function balanceOf(address _who) external view returns (uint256);

    function allowance(
        address _owner,
        address _spender
    ) external view returns (uint256);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}
