// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Bridge  {
    IAxelarGateway public immutable GoerliGateway;
    string public tokenId;
    address public admin;
    IERC20 OriginTokenAddress;

    constructor(IERC20 _OriginTokenAddress)  {
        admin = msg.sender;
        GoerliGateway = IAxelarGateway(0x7cD2E96f5258BB825ad6FC0D200EDf8C99590d30);
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

    function executeBridge(string calldata destinationChain, uint256 amountToBridge, string memory symbol)  external {
        require(amountToBridge > 0, "No request");
        // if(tokenId = 0) {
        //   revert("Invalid tokenID! please configure and set interchain token and Id first.");
        // }
        uint bal = OriginTokenAddress.balanceOf(msg.sender);
        require(bal > 0 && bal >= amountToBridge, "CTK: Insufficient balance");

        address GoerliGatewayAddress = address(GoerliGateway);
        OriginTokenAddress.approve(GoerliGatewayAddress, amountToBridge);
        GoerliGateway.sendToken(
        tokenId,
        destinationChain,
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