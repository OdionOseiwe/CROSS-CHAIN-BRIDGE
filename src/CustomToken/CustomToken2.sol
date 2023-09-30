// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ITokenManager} from "interchain-token-service/interfaces/ITokenManager.sol";
import {ITokenManagerType} from "interchain-token-service/interfaces/ITokenManagerType.sol";
import {IInterchainToken} from "interchain-token-service/interfaces/IInterchainToken.sol";
import {IInterchainTokenService} from "interchain-token-service/interfaces/IInterchainTokenService.sol";
import {AddressBytesUtils} from "interchain-token-service/libraries/AddressBytesUtils.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract CustomToken2 {
    using AddressBytesUtils for address;

    ITokenManager public tokenManager;
    IInterchainTokenService public service =
    IInterchainTokenService(0xF786e21509A9D50a9aFD033B5940A2b7D872C208);

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor()  {
        // _mint(msg.sender, 1000 * 10 ** decimals());
        // _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        // _grantRole(MINTER_ROLE, msg.sender);
        deployTokenManager("");
    }

    //function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
    //     _mint(to, amount);
    // }

    // function customMint() public {
    //     _mint(msg.sender, 5 * (10**uint256(18)));
    // }

    // function burn(address account, uint256 amount) public onlyRole(MINTER_ROLE) {
    //     _burn(account, amount);
    // }

    function deployTokenManager(bytes32 salt) internal {
        bytes memory params = service.getParamsMintBurn(
            msg.sender.toBytes(),
            address(this)
        );
        bytes32 tokenId = service.deployCustomTokenManager(
            salt,
            ITokenManagerType.TokenManagerType.MINT_BURN,
            params
        );
        tokenManager = ITokenManager(service.getTokenManagerAddress(tokenId));
    }

    // /*
    //  * Deploy this token, then register it with the Interchain Token Service
    //  * You'll be given a TokenManager which you can set here, allowing the
    //  * local send methods to function.
    //  */
    // function setTokenManager(address _tokenManager) public onlyRole(MINTER_ROLE) {
    //     tokenManager = ITokenManager(_tokenManager);
    // }

    // /**
    //  * @notice Implementation of the interchainTransfer method
    //  * @dev We chose to either pass `metadata` as raw data on a remote contract call, or, if no data is passed, just do a transfer.
    //  * A different implementation could have `metadata` that tells this function which function to use or that it is used for anything else as well.
    //  * @param destinationChain The destination chain identifier.
    //  * @param recipient The bytes representation of the address of the recipient.
    //  * @param amount The amount of token to be transfered.
    //  */
    // function sendToken(
    //     string calldata destinationChain,
    //     address recipient,
    //     uint256 amount
    // ) external payable {

    //     // Metadata semantics are defined by the token service and thus should be passed as-is.
    //     tokenManager.sendToken{value: msg.value}(
    //         destinationChain,
    //         abi.encode(recipient),
    //         amount * (10**uint256(18)) ,
    //         ''
    //     );
    // }

    // /**
    //  * @notice Implementation of the interchainTransferFrom method
    //  * @dev We chose to either pass `metadata` as raw data on a remote contract call, or, if no data is passed, just do a transfer.
    //  * A different implementation could have `metadata` that tells this function which function to use or that it is used for anything else as well.
    //  * @param sender the sender of the tokens. They need to have approved `msg.sender` before this is called.
    //  * @param destinationChain the string representation of the destination chain.
    //  * @param recipient the bytes representation of the address of the recipient.
    //  * @param amount the amount of token to be transfered.
    //  * @param metadata either empty, to just facilitate a cross-chain transfer, or the data to be passed to a cross-chain contract call and transfer.
    //  */
    // function interchainTransferFrom(
    //     address sender,
    //     string calldata destinationChain,
    //     bytes calldata recipient,
    //     uint256 amount,
    //     bytes calldata metadata
    // ) external payable {
    //     uint256 _allowance = allowance(sender, msg.sender);

    //     if (_allowance != type(uint256).max) {
    //         _approve(sender, msg.sender, _allowance - amount);
    //     }

    //     tokenManager.transmitInterchainTransfer{value: msg.value}(
    //         sender,
    //         destinationChain,
    //         recipient,
    //         amount,
    //         metadata
    //     );
    // }
}


//grantrole to tokenmanger on both chains
//approve tokenmanger to use your tokens

