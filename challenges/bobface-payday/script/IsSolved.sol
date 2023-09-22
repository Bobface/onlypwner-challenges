pragma solidity 0.8.20;

import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";

contract IsSolved is Script {
    function run() external view {
        address distributor = vm.envAddress("Distributor");
        uint256 maxBalance = 1 ether;

        if (distributor.balance >= maxBalance) {
            console.log("is-solved:false");
            return;
        }

        address[20] memory addresses = [
            0x5302f28bc16F3d09EEa8B58a366F2cebA6A77EA2,
            0x894f2b17DD075E3D63b22C9d12e0A04b8d248E29,
            0x117163d37a2A1C2E2ff5F83cEe491d514b638Eb5,
            0x33C05357571E6e9d96a230757CFdb90adAA91964,
            0x4722E5465c175f21310c3dBc612E54e97305bf94,
            0xa32bC07Bd996deCAb23C8309d9d370AdA6Fb3074,
            0x055CE6790F1575C54e64931f4BEd9fE9D3e0a531,
            0x2E3F54B36C9BECfbF9F16bf4E527fcf3Df66Faad,
            0x463a7E2d02822937Bc9Dd3FE2774Fa078d77Da1b,
            0x31b0167e8db21e5F984e68C3FAeee4403f81Ca61,
            0x3daC588a7f9CA0141AAe41842F60a1B508508A76,
            0x87e4D623797b9Aa5EFeD2E2cd98A50E995DF9517,
            0xC35f389c159dD1E5D0450AC2783EC87618c02888,
            0x1Bd4106e65857F76f101add471814A2351374e00,
            0x5173a9B1EaB8e295eA2BafDB3a79FE00EFCB86E5,
            0xCD4a11C2DEd044d69016DF835e40A44a77035E57,
            0x392Ab9BA877af1cb2F9c6e1cA6f15978Cf622ACe,
            0xc86fB78b864aE0589EEe675AC412Ae2a7ea3D5E5,
            0x7BA5D0B36725E321F79eE797f6126Dc433801D0E,
            0xb17ca57e7166476767FD940d35940fA2a38184bb
        ];

        for (uint256 i = 0; i < addresses.length; i++) {
            if (addresses[i].balance > 0) {
                console.log("is-solved:false");
                return;
            }
        }

        console.log("is-solved:true");
    }
}
