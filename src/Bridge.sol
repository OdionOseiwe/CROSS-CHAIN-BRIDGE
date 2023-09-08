// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Bridge  {
    IAxelarGateway public immutable CeloGateway;
    string public tokenId;
    address public admin;
    IERC20 OriginTokenAddress;

    constructor(IERC20 _OriginTokenAddress)  {
        admin = msg.sender;
        CeloGateway = IAxelarGateway(0xe432150cce91c13a887f7D836923d5597adD8E31);
        OriginTokenAddress = _OriginTokenAddress;
    }

    function setTokenId(string memory _tokenId) public {
        require(msg.sender == admin, "Not an admin");
        tokenId = _tokenId;
    }

    function requestFreeToken() public {
        uint amount = 1000 * (10 ** 18);
        OriginTokenAddress.transfer(msg.sender, amount);
    }

    function executeBridge(string calldata destinationChain,string memory destinationAddress, string memory symbol , uint256 amountToBridge)  external {
        require(amountToBridge > 0, "No request");
        // if(tokenId = 0) {
        //   revert("Invalid tokenID! please configure and set interchain token and Id first.");
        // }
        uint bal = OriginTokenAddress.balanceOf(msg.sender);
        require(bal > 0 && bal >= amountToBridge, "Bridge: Insufficient balance");

        address CeloGatewayAddress = address(CeloGateway);
        OriginTokenAddress.approve(CeloGatewayAddress, amountToBridge);
        CeloGateway.sendToken(
        destinationChain,
        destinationAddress,
        symbol ,
        amountToBridge
        );
    }
}

interface IAxelarGateway {
    function sendToken(
        string memory destinationChain,
        string memory destinationAddress,
        string memory symbol,
        uint256 amount
    ) external;
}

///0xB42071eF8901912Cc92A59De04f6d49dd58a88A8 celoTokenAddress

///0x6E309a55761a5E60dfcd7c9A470205101414ecC3 BridgeAddress

