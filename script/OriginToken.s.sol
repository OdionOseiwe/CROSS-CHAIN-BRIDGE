// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {OriginToken} from "../src/OriginToken.sol";

contract OriginTokenScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        OriginToken origintoken = new OriginToken("GoerliToken", "GT",  100 * (10**uint256(18)));
        vm.stopBroadcast();    
    }

    
}




