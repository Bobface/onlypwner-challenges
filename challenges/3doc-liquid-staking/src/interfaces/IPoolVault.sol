pragma solidity ^0.8.20;

interface IPoolVault {
    function depositFor(address synthetic, address beneficiary, uint amount) external;

    function withdraw(address synthetic, uint amount) external;

    function balance(address synthetic, address owner) external view returns(uint);
}
