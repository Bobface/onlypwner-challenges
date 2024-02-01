pragma solidity 0.8.21;

interface ISyntheticTokenFactory {
    function currentSequence() external view returns (uint);

    function mintedSupply() external view returns (uint);

    function feeReceiver() external view returns (address);

    function synthetics(uint) external view returns (address);

    function syntheticsLength() external view returns (uint);

    function isActive(address synthetic) external view returns (bool);

    function createSynthetic() external payable returns (address);

    function redeemTokens(address synthetic, uint amount) external;

}
