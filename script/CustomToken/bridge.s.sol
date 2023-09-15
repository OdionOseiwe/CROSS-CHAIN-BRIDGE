// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

contract BridgeScript is Script {
    function setUp() public {}

    IInterchainTransfer constant iinterchainTransfer = IInterchainTransfer(0x343c5a91Df775e59E887A53c940EBE6cb8f91030);

    function run() external {
        vm.startBroadcast();
            iinterchainTransfer.interchainTransfer(
            "ethereum-2",
            abi.encode(0x0806C90bA14284f8EC1F6aF35aC68928FAa2D811),
            1 * (10**uint256(18)) ,
            ''
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
}