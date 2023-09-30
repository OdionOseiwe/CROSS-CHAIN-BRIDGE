// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

contract BridgeScript is Script {

    IInterchainTransfer constant
    iinterchainTransfer = IInterchainTransfer( 0x8A0777aCf95577Fb0F63BC8aE8aF3984Ed073277);  

    ITokenManager constant TokenManager = ITokenManager(0x487738FA55d203fb63bc5c4d707100FC33818394);

    function setUp() public {}

    function run() external {

        vm.startBroadcast();
            iinterchainTransfer.mintForAll(0x6644EA302A634e131F4afD73E744f03271A13d1E, 10 * (10**uint256(18)));
            iinterchainTransfer.approve(0x487738FA55d203fb63bc5c4d707100FC33818394,5 * (10**uint256(18)));
            TokenManager.sendToken(
                "ethereum-2",
                abi.encode(0x6644EA302A634e131F4afD73E744f03271A13d1E),
                1 * (10**uint256(18)) ,
                ''
            );       
        vm.stopBroadcast();    
    }
}


interface IInterchainTransfer{
    function sendToken(
        string calldata destinationChain,
        address  recipient,
        uint256 amount
    ) external payable;

    function mintForAll(address to, uint256 amount) external;

    function approve(address spender, uint256 value) external returns (bool);
    
    function grantRole(bytes32 role, address account) external;
}

 // from celo to goerli

interface ITokenManager  {
    function sendToken(
        string calldata destinationChain,
        bytes calldata destinationAddress,
        uint256 amount,
        bytes calldata metadata
    ) external;
}
// https://goerli.infura.io/v3/625725aff2fc4b10af162d3804eb52e5
// forge script script/CustomToken/deployIn.s.sol:deployInscript --rpc-url https://goerli.infura.io/v3/625725aff2fc4b10af162d3804eb52e5 --private-key 20fdc71dc348f8ad561f3f3d4f168605853d66983c3efff9e7aa440c9ed85f5e --broadcast --verify -vvvv

// 0x270c842FDD432c65Ad7e32279B0B1fdAF2A87e79 TOKEN MANGER CELO

// 0x53a7DA9e9b2237c86b5A29ce1541bF2b6D803767 CELO TOKEN

// 0xaA86A3635F597aEb4B41c0f4ccdB1DE0a92275C1 GOERLI TOKEN

// 0x36e53f02dC8a30a23DC99c6a7547A85Bd5E34697 TOKEN MANGER


