// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { InterchainToken } from '../interchain-token/InterchainToken.sol';
import { Distributable } from '../utils/Distributable.sol';
import { ITokenManager } from '../interfaces/ITokenManager.sol';
import { IERC20BurnableMintable } from '../interfaces/IERC20BurnableMintable.sol';

contract FeeOnTransferTokenTest is InterchainToken, Distributable, IERC20BurnableMintable {
    ITokenManager public tokenManager_;
    bool internal tokenManagerRequiresApproval_ = true;
    string public name;
    string public symbol;
    uint8 public decimals;

    constructor(string memory name_, string memory symbol_, uint8 decimals_, address tokenManagerAddress) {
        name = name_;
        symbol = symbol_;
        decimals = decimals_;
        _setDistributor(msg.sender);
        tokenManager_ = ITokenManager(tokenManagerAddress);
    }

    function tokenManager() public view override returns (ITokenManager) {
        return tokenManager_;
    }

    function _beforeInterchainTransfer(
        address sender,
        string calldata /*destinationChain*/,
        bytes calldata /*destinationAddress*/,
        uint256 amount,
        bytes calldata /*metadata*/
    ) internal override {
        if (!tokenManagerRequiresApproval_) return;
        address tokenManagerAddress = address(tokenManager_);
        uint256 allowance_ = allowance[sender][tokenManagerAddress];
        if (allowance_ != type(uint256).max) {
            if (allowance_ > type(uint256).max - amount) {
                allowance_ = type(uint256).max - amount;
            }

            _approve(sender, tokenManagerAddress, allowance_ + amount);
        }
    }

    function setTokenManagerRequiresApproval(bool requiresApproval) public {
        tokenManagerRequiresApproval_ = requiresApproval;
    }

    function mint(address account, uint256 amount) external onlyDistributor {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) external onlyDistributor {
        _burn(account, amount);
    }

    function setTokenManager(ITokenManager tokenManagerAddress) external {
        tokenManager_ = tokenManagerAddress;
    }

    // Always transfer 10 less base tokens.
    function _transfer(address sender, address recipient, uint256 amount) internal override {
        if (sender == address(0) || recipient == address(0)) revert InvalidAccount();

        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount - 10;
        emit Transfer(sender, recipient, amount);
    }
}
