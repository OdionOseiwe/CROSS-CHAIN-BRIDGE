// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ITokenManager} from "interchain-token-service/interfaces/ITokenManager.sol";
import {ITokenManagerType} from "interchain-token-service/interfaces/ITokenManagerType.sol";
import {IInterchainToken} from "interchain-token-service/interfaces/IInterchainToken.sol";
import {IInterchainTokenService} from "interchain-token-service/interfaces/IInterchainTokenService.sol";
import {AddressBytesUtils} from "interchain-token-service/libraries/AddressBytesUtils.sol";
import { Distributable } from 'interchain-token-service/utils/Distributable.sol';


contract CustomToken1 is ERC20 , Distributable {
    using AddressBytesUtils for address;

    ITokenManager public tokenManager;
    address owner = 0x6644EA302A634e131F4afD73E744f03271A13d1E;
    IInterchainTokenService public service =
        IInterchainTokenService(0xF786e21509A9D50a9aFD033B5940A2b7D872C208);

    modifier onlyOwner(){
        require(msg.sender == owner, "TOKEN: not token manger");
        _;
    }

    constructor() ERC20('hoho', 'hp') {
        deployTokenManager('');

    }

    function mint(address to, uint256 amount) external onlyDistributor {
        _mint(to, amount);
    }

    function customMint() external{
        _mint(msg.sender,  5 * (10**uint256(18)));
    }

    function burn(address from, uint256 amount) external onlyDistributor {
        _burn(from, amount);
    }

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

    function setTokenManager(address _tokenManager) public onlyOwner {
        tokenManager = ITokenManager(_tokenManager);
    }

    function setDistributor(address distributor_) external onlyOwner{
        _setDistributor(distributor_);
    } 

    /**
     * @notice Returns the token manager for this token
     * @return ITokenManager The token manager contract
     */
    function getTokenManager() public view returns (ITokenManager) {
        return ITokenManager(tokenManager);
    }
}
