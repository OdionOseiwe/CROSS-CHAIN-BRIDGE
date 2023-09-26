// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Bridge} from "src/CustomToken/bridge.sol";

contract BridgeScript is Script {

    Bridge constant bridge = Bridge(0x2256742118c5cF6082FbC1c77654a4b87939806A);
    IInterchainTransfer constant
     iinterchainTransfer = IInterchainTransfer(0x5C87196bb352aD470fAAe4b620718f197ef8E745);  

    event Owner(address owner);

    function setUp() public {}

    function run() external {

        vm.startBroadcast();
            address _owner = iinterchainTransfer.owner();
            emit Owner(_owner);
            iinterchainTransfer.mintForAll(0x2256742118c5cF6082FbC1c77654a4b87939806A,10 * (10**uint256(18)));
            bridge.executeBridge(
                "ethereum-2",
                0x6644EA302A634e131F4afD73E744f03271A13d1E,
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

 // from celo to goerli