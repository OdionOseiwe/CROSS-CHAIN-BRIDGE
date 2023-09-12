// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

///@dev OriginToken is deployed on Celo

contract  OriginToken is ERC20{
    address public admin;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply
    ) ERC20(_name, _symbol) {
        // mint all tokens and send them to the deployer's wallet
        _mint(msg.sender, _initialSupply * (10**uint256(18)));
        admin = msg.sender;
    }

    function requestFreeToken() public {
        uint amount = 1000 * (10 ** 18);
        transfer(msg.sender, amount);
    }    
}