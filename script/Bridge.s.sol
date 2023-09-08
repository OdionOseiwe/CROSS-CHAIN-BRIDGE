// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Bridge} from "../src/Bridge.sol";

contract BridgeScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        Bridge bridge = new Bridge(IERC20(0xB42071eF8901912Cc92A59De04f6d49dd58a88A8));
        vm.stopBroadcast();    
    }
}


