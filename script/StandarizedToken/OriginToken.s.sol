// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Bridge} from "src/StandarizedToken/bridge.sol";

contract interactScript is Script {
    function setUp() public {}

    Bridge constant bridge = Bridge(0x5D4bD5f38a21d8BddBbB6660B058833f966BB4c9);

    function run() external {
        vm.startBroadcast();
        bridge.executeBridge("Avalanche",0x0806C90bA14284f8EC1F6aF35aC68928FAa2D811,1 * (10**uint256(18)));
        vm.stopBroadcast();    
    }
}

