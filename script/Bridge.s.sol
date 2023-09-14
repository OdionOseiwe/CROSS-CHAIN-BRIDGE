// 0x805b8839c80a494d2c20005154dd1a51964efcea92c44a4a706a30255dcc2ebe


// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Bridge} from "../src/StandarizedToken/Bridge.sol";

contract BridgeScript is Script {
    function setUp() public {}

    function run() external {
        vm.startBroadcast();
        Bridge bridge = new Bridge( 0xa1094134b869f61C0267e0F46dbAfD0421F14bB1);
        vm.stopBroadcast();    
    }
}

