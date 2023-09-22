pragma solidity 0.8.20;

interface IMulticall {
    function multicall(
        bytes[] calldata data
    ) external payable returns (bytes[] memory results);
}
