// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

contract ApproveScript is Script {

    IInterchainTransfer constant iinterchainTransfer = IInterchainTransfer(0x676271Ec5e329A5c1AE7025D41f318a15FBe028d);  
    function setUp() public {}

    function run() external {
        vm.startBroadcast();
            iinterchainTransfer.approve(0x999117D44220F33e0441fbAb2A5aDB8FF485c54D, 1* (10**uint256(18)) );
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

 


           
           
