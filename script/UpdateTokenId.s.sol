// 0x805b8839c80a494d2c20005154dd1a51964efcea92c44a4a706a30255dcc2ebe


// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Bridge} from "../src/Bridge.sol";

contract UpdateScript is Script {
    function setUp() public {}

    Bridge constant bridge = Bridge(0x6E309a55761a5E60dfcd7c9A470205101414ecC3);


    function run() external {
        vm.startBroadcast();
        bridge.setTokenId("0x805b8839c80a494d2c20005154dd1a51964efcea92c44a4a706a30255dcc2ebe");
        bridge.executeBridge("Ethereum-2","0x0806C90bA14284f8EC1F6aF35aC68928FAa2D811", "GT",100000);
        vm.stopBroadcast();    
    }
}


