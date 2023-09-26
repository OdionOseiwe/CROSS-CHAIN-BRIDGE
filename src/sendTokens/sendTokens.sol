
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract  Bridge{
   IsendToken isendToken =  IsendToken(0x999117D44220F33e0441fbAb2A5aDB8FF485c54D);
   IERC20 token = IERC20(0xCb7996d51Ff923b2C6076d42C065a6ca000D32A1);
    function bridge() external {
        token.approve(0x999117D44220F33e0441fbAb2A5aDB8FF485c54D, 1 * (10**uint256(18)) );
        isendToken.sendToken('ethereum-2', '0x6644EA302A634e131F4afD73E744f03271A13d1E', 'aUSDC', 100000000 );
    }
}


interface IsendToken {
    function sendToken(
    string memory destinationChain,
    string memory destinationAddress,
    string memory symbol,
    uint256 amount
    ) external;
}

//zk to goerli