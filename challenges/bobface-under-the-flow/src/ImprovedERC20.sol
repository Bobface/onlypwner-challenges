pragma solidity ^0.7.0;

import {IImprovedERC20} from "./interfaces/IImprovedERC20.sol";

contract ImprovedERC20 is IImprovedERC20 {
    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) public override allowance;
    address public override owner;

    string public override name;
    string public override symbol;
    uint8 public override decimals;

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        owner = msg.sender;
        balanceOf[msg.sender] = _initialSupply;
    }

    function transfer(
        address _to,
        uint256 _value
    ) external override returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external override returns (bool) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(
            allowance[_from][msg.sender] - _value > 0,
            "Insufficient allowance"
        );
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        return true;
    }

    function approve(
        address _spender,
        uint256 _value
    ) external override returns (bool) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function mint(uint256 _value) external override {
        require(msg.sender == owner, "Only owner can mint");
        balanceOf[msg.sender] += _value;
    }

    function burn(address _who, uint256 _value) external override {
        require(balanceOf[_who] >= _value, "Insufficient balance");
        balanceOf[_who] -= _value;
    }
}
