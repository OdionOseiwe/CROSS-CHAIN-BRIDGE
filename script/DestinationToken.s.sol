// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {DestinationToken} from "../src/DestinationToken.sol";

contract DestinationTokenScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        DestinationToken destinationtoken = new DestinationToken(0x868369f273459d25B407ebE22F6BC8B5b1E393E8);
        vm.stopBroadcast();    
    }
}

