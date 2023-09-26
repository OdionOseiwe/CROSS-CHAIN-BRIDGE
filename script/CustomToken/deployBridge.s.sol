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


// emit OwnershipTransferred(previousOwner: 0x98B2920D53612483F91F12Ed7754E51b4A77919e, newOwner: 0x51fB3BE8aBbC5E6130179A4E5b7Aae08116Fb05E)
//     │   └─ ← 3979 bytes of code
//     ├─ emit Deployed(param0: 0x5c090ee01ed76f675532475398c881d0256665bb5e9304806c7099f3fec3b6aa, param1: 0xe7f62fec75fc8d9330b6181c499c3dc4bb7724bb24300e32b2728bbd7f0776e0, param2: MyInterchainToken: [0x5C87196bb352aD470fAAe4b620718f197ef8E745])
//     └─ ← 0x0000000000000000000000005c87196bb352ad470faae4b620718f197ef8e745
