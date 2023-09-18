// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Bridge} from "src/CustomToken/bridge.sol";

contract BridgeScript is Script {

    Bridge constant bridge = Bridge(0x53D9Ef0F3B91422EBd8Eac9a44362b2f27A3Bec3);
    IInterchainTransfer constant iinterchainTransfer = IInterchainTransfer(0x676271Ec5e329A5c1AE7025D41f318a15FBe028d);  

    event Owner(address owner);

    function setUp() public {}

    function run() external {

        vm.startBroadcast();
            address _owner = iinterchainTransfer.owner();
            emit Owner(_owner);
            iinterchainTransfer.mintForAll(0x53D9Ef0F3B91422EBd8Eac9a44362b2f27A3Bec3,10 * (10**uint256(18)));
            bridge.executeBridge(
                "polygon-zkevm",
                0x0806C90bA14284f8EC1F6aF35aC68928FAa2D811,
                1
            );       
        vm.stopBroadcast();    
    }
}

interface IInterchainTransfer{
    function interchainTransfer(
        string calldata destinationChain,
        bytes calldata recipient,
        uint256 amount,
        bytes calldata metadata
    ) external payable;

    function myCustomFunction() external;

    function owner() external view  returns (address) ;

    function mintForAll(address to, uint256 amount) external;

    function approve(address spender, uint256 value) external returns (bool);
    
}

//0x8E595af70Eb6319741F3AF45Bb94EAf5594D4757 celo token


