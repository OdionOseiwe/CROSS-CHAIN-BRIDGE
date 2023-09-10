// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.13;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// contract Bridge  {
//     IInterChainLinker public immutable AxelarLinker;
//     bytes32 tokenId;
//     address public admin;
//     IERC20 tokenAddress;

//     constructor(IERC20 _tokenAddress)  {
//         admin = msg.sender;
//         AxelarLinker = IInterChainLinker( 0x7cD2E96f5258BB825ad6FC0D200EDf8C99590d30);
//         tokenAddress = _tokenAddress;
//     }

//     function setTokenId(bytes32 _tokenId) public {
//         require(msg.sender == admin, "Not an admin");
//         tokenId = _tokenId;
//     }

//     function requestFreeToken() public {
//         uint amount = 1000 * (10 ** 18);
//         tokenAddress.transfer(msg.sender, amount);
//     }

//     function executeBridge(string calldata destinationChain,address recipient, uint256 amountToBridge)  external payable {
//         require(amountToBridge > 0, "No request");
//         // if(tokenId == 0) {
//         //   revert("Invalid tokenID! please configure and set interchain token and Id first.");
//         // }
//         uint bal = tokenAddress.balanceOf(address(this));
//         require(bal > 0 && bal >= amountToBridge, "Bridge: Insufficient balance");

//         address AxelarLinkerAddress = address(AxelarLinker);
//         tokenAddress.approve(AxelarLinkerAddress, amountToBridge);
//         AxelarLinker.interchainTransfer{value: msg.value}(
//         destinationChain,
//         abi.encode(recipient),
//         amountToBridge ,
//         abi.encode('')
//         );
//     }
// }

// interface IInterChainLinker {
//     function interchainTransfer(
// 	string calldata destinationChain,
// 	bytes calldata recipient,
// 	uint256 amount,
// 	bytes calldata metadata
//     ) external payable;
// }

// ///0x39ceeD0C9ad02155dF5ed864e294FBaf6B45801a celoTokenAddress

// ///0xEAc6fC8F01F9D5E52e2447a9365D5d06f8271071 BridgeAddress

