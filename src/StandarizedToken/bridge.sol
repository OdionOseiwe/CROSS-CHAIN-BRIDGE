// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";



contract  Bridge{
    address public admin;
    IInterChainLinker token;

    constructor(address _token){
        admin = msg.sender;
        token = IInterChainLinker(_token);
    }  

    function executeBridge(string calldata destinationChain,address recipient, uint256 amountToBridge)  external payable {
        require(amountToBridge > 0, "No request");
        uint bal = token.balanceOf(address(this));
        require(bal > 0 && bal >= amountToBridge, "Bridge: Insufficient balance");
        token.approve(address(this), amountToBridge);
        token.interchainTransfer{value: msg.value}(
            destinationChain,
            abi.encode(recipient),
            amountToBridge ,
            ''
        );
    }
}

interface IInterChainLinker is IERC20{
    function interchainTransfer(
	string calldata destinationChain,
	bytes calldata recipient,
	uint256 amount,
	bytes calldata metadata
    ) external payable;
}

/// 0x266dA2aecc9451c32060f0D1EdF03d7940633E07 celotoken

/// 0x5D4bD5f38a21d8BddBbB6660B058833f966BB4c9 bridge

// forge script script/interact.s.sol:interactScript --rpc-url https://celo-alfajores.infura.io/v3/e7af8fc766b941c498bc770af5246568 --private-key 09b170d30e02cf22c291dac78a29ee424db3a4b2187535fbe8aa81185b2d3513 --broadcast --verify -vvvv