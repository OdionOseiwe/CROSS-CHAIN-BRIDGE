// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Bridge} from "src/CustomToken/bridge.sol";

contract BridgeScript is Script {

    Bridge constant bridge = Bridge(0xD5068184EdaC8C87a443fF60611ba6cD53365C56);
    IInterchainTransfer constant iinterchainTransfer = IInterchainTransfer(0xa410f09Fe3cEf871b1Bb031025742E435369F927);  

    event Owner(address owner);

    function setUp() public {}

    function run() external {

        vm.startBroadcast();
            address _owner = iinterchainTransfer.owner();
            emit Owner(_owner);
            iinterchainTransfer.mintForAll(0xD5068184EdaC8C87a443fF60611ba6cD53365C56,10 * (10**uint256(18)));
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

 