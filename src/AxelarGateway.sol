// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AxelarGateway  {
    IAxelarGateway public immutable AxelarGateway;
    address public admin;
    IERC20 token;
    
    // celo to avalanche

    constructor(address _token)  {
        admin = msg.sender;
        AxelarGateway = IAxelarGateway( 0xe432150cce91c13a887f7D836923d5597adD8E31);
        token = IERC20(_token);
    }

    function send() public{
        uint256 amount = 1* 10 ** 6;
        token.approve(address(AxelarGateway), amount);
        AxelarGateway.sendToken("Avalanche","0x0806C90bA14284f8EC1F6aF35aC68928FAa2D811","aUSDC",amount);
    }
}


interface IAxelarGateway{
    function sendToken(
    string memory destinationChain,
    string memory destinationAddress,
    string memory symbol,
    uint256 amount
    ) external;
}


