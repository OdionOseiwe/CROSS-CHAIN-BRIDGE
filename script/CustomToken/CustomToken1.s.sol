// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {ITokenManager} from "interchain-token-service/interfaces/ITokenManager.sol";


contract CustomToken1Script is Script {

    IInterchainTransfer constant
    iinterchainTransfer = IInterchainTransfer( 0x2F05A8702ed0377460e40fe479918e48EA3dfcFa);  

    ITokenManager constant TokenManager = ITokenManager(0x4a0CD6b638e5B069Aa34FaFc39bB75D993edF8E9);

    function setUp() public {}

    function run() external {

        vm.startBroadcast();
            // iinterchainTransfer.customMint();
            // iinterchainTransfer.setDistributor(0x4a0CD6b638e5B069Aa34FaFc39bB75D993edF8E9);
            // iinterchainTransfer.getTokenManager();
            // iinterchainTransfer.approve(0x4a0CD6b638e5B069Aa34FaFc39bB75D993edF8E9,5 * (10**uint256(18)));
            TokenManager.sendToken{value: 0.5 ether}(
                "ethereum-2",
                abi.encode(0x6644EA302A634e131F4afD73E744f03271A13d1E),
                1e18,
                hex"00"
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

    function customMint() external;

    function approve(address spender, uint256 value) external returns (bool);
    
    function setDistributor(address distributor_) external;
    function getTokenManager() external  returns (ITokenManager);

}

// https://goerli.infura.io/v3/e7af8fc766b941c498bc770af5246568
// https://celo-alfajores.infura.io/v3/e7af8fc766b941c498bc770af5246568 