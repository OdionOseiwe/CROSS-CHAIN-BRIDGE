// 0x805b8839c80a494d2c20005154dd1a51964efcea92c44a4a706a30255dcc2ebe


// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Bridge} from "../src/Bridge.sol";

contract interactScript is Script {
    function setUp() public {}

    Bridge constant bridge = Bridge(0xCE1aBEC519F1083AD1E583dDe755c58D19ae4dDF);


    function run() external {
        vm.startBroadcast();
        // bridge.setTokenId("0x3c126e158185d23702e016032f8b263d19832e916bf12c9584cc8300a4390234");
        bridge.executeBridge("avalanche","0x0806C90bA14284f8EC1F6aF35aC68928FAa2D811",1 * (10**uint256(18)));
        vm.stopBroadcast();    
    }
}

