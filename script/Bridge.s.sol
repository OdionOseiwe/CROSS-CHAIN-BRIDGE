// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Bridge} from "../src/Bridge.sol";

contract BridgeScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        Bridge bridge = new Bridge(IERC20(0xa1094134b869f61C0267e0F46dbAfD0421F14bB1));
        vm.stopBroadcast();    
    }
}


