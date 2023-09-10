// 0x805b8839c80a494d2c20005154dd1a51964efcea92c44a4a706a30255dcc2ebe


// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {AxelarGateway} from "../src/AxelarGateway.sol";

contract AxelarGatewayScript is Script {
    function setUp() public {}

    AxelarGateway constant axelarGateway = AxelarGateway(0x204f79852387C0d68f3C78DB0941eEe92457da3d);

    function run() external {
        vm.startBroadcast();
        axelarGateway.send();
        vm.stopBroadcast();    
    }
}

