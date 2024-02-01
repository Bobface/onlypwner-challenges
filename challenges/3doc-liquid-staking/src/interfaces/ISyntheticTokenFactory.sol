pragma solidity ^0.8.20;

interface ISyntheticTokenFactory {
    function synthetics(uint) external view returns (address);

    function syntheticsLength() external view returns(uint);

    function createSynthetic() external payable returns(address);

    function redeemTokens(address synthetic, uint amount) external;

}
