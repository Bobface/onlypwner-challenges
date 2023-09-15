pragma solidity ^0.8.20;

interface ITarget {
    function first() external returns (bytes32);

    function second() external returns (bytes32);

    function third() external returns (bytes32);
}
