// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Bridge} from "src/CustomToken/bridge.sol";

contract deployBridgeScript is Script {
    function setUp() public {}

    function run() external {
        vm.startBroadcast();
        Bridge bridge = new Bridge();
        vm.stopBroadcast();    
    }
}


