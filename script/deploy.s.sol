// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {AxelarGateway} from "../src/AxelarGateway.sol";

contract deployScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        AxelarGateway axelarGateway = new AxelarGateway(0x254d06f33bDc5b8ee05b2ea472107E300226659A);
        vm.stopBroadcast();    
    } 
}





