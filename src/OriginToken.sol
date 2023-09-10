// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract  OriginToken is ERC20{

    IInterChainLinker public immutable AxelarLinker;
    bytes32 tokenId;
    address public admin;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply
    ) ERC20(_name, _symbol) {
        // mint all tokens and send them to the deployer's wallet
        _mint(msg.sender, _initialSupply * (10**uint256(18)));
        admin = msg.sender;
        AxelarLinker = IInterChainLinker( 0x7cD2E96f5258BB825ad6FC0D200EDf8C99590d30);
    }    

    function executeBridge(string calldata destinationChain,address recipient, uint256 amountToBridge)  external payable {
        require(amountToBridge > 0, "No request");
        // if(tokenId == 0) {
        //   revert("Invalid tokenID! please configure and set interchain token and Id first.");
        // }
        uint bal = balanceOf(msg.sender);
        require(bal > 0 && bal >= amountToBridge, "Bridge: Insufficient balance");

        address AxelarLinkerAddress = address(AxelarLinker);
        approve(AxelarLinkerAddress, amountToBridge);
        AxelarLinker.interchainTransfer{value: msg.value}(
        destinationChain,
        abi.encode(recipient),
        amountToBridge ,
        abi.encode('')
        );
    }
}

interface IInterChainLinker {
    function interchainTransfer(
	string calldata destinationChain,
	bytes calldata recipient,
	uint256 amount,
	bytes calldata metadata
    ) external payable;
}


