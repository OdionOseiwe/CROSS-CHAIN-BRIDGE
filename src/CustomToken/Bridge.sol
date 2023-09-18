// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract  Bridge{
    IInterchainTransfer constant iinterchainTransfer = IInterchainTransfer(0x676271Ec5e329A5c1AE7025D41f318a15FBe028d);  

    function executeBridge(string calldata destinationChain,address recipient, uint256 amountToBridge)  external payable {
        require(amountToBridge > 0, "No request");
        uint bal = iinterchainTransfer.balanceOf(address(this));
        require(bal > 0 && bal >= amountToBridge, "Bridge: Insufficient balance");
        iinterchainTransfer.approve(address(this), amountToBridge);
        iinterchainTransfer.interchainTransfer(
            destinationChain,
            abi.encode(recipient),
            amountToBridge * (10**uint256(18)) ,
            ''
        ) ;   
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
    
    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);
    
}


