// 0x805b8839c80a494d2c20005154dd1a51964efcea92c44a4a706a30255dcc2ebe


// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {OriginToken} from "../src/OriginToken.sol";

contract interactScript is Script {
    function setUp() public {}

    OriginToken constant origintoken = OriginToken(0xb48CE30A5267De8ABa38d2D15901d9db7000BD51);

    function run() external {
        vm.startBroadcast();
        origintoken.executeBridge("Avalanche",0x0806C90bA14284f8EC1F6aF35aC68928FAa2D811,1 * (10**uint256(18)));
        vm.stopBroadcast();    
    }
}

