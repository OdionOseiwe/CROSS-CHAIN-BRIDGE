'use strict';

const chai = require('chai');
const { expect } = chai;
require('dotenv').config();
const { ethers } = require('hardhat');
const { AddressZero } = ethers.constants;
const { defaultAbiCoder, keccak256 } = ethers.utils;
const { Contract, Wallet } = ethers;

const IStandardizedToken = require('../artifacts/contracts/interfaces/IStandardizedToken.sol/IStandardizedToken.json');
const ITokenManager = require('../artifacts/contracts/interfaces/ITokenManager.sol/ITokenManager.json');

const { getRandomBytes32 } = require('../scripts/utils');
const { deployAll, deployContract } = require('../scripts/deploy');

const SELECTOR_SEND_TOKEN = 1;
// const SELECTOR_SEND_TOKEN_WITH_DATA = 2;
// const SELECTOR_DEPLOY_TOKEN_MANAGER = 3;
const SELECTOR_DEPLOY_AND_REGISTER_STANDARDIZED_TOKEN = 4;

const LOCK_UNLOCK = 0;
const MINT_BURN = 1;
// const LIQUIDITY_POOL = 2;

describe('Interchain Token Service', () => {
    let wallet;
    let service, gateway, gasService, tokenManager, tokenId;
    const name = 'tokenName';
    const symbol = 'tokenSymbol';
    const decimals = 18;

    before(async () => {
        const wallets = await ethers.getSigners();
        wallet = wallets[0];
        [service, gateway, gasService] = await deployAll(wallet, 'Test');
    });

    describe('Full canonical token registration, remote deployment and token send', async () => {
        let token;
        const otherChains = ['chain 1', 'chain 2'];
        const gasValues = [1234, 5678];
        const tokenCap = BigInt(1e18);

        before(async () => {
            // The below is used to deploy a token, but any ERC20 can be used instead.
            token = await deployContract(wallet, 'InterchainTokenTest', [name, symbol, decimals, wallet.address]);
            tokenId = await service.getCanonicalTokenId(token.address);
            const tokenManagerAddress = await service.getTokenManagerAddress(tokenId);
            await (await token.mint(wallet.address, tokenCap)).wait();
            await (await token.setTokenManager(tokenManagerAddress)).wait();
            tokenManager = new Contract(tokenManagerAddress, ITokenManager.abi, wallet);
        });

        it('Should register the token and initiate its deployment on other chains', async () => {
            const tx1 = await service.populateTransaction.registerCanonicalToken(token.address);
            const data = [tx1.data];
            let value = 0;

            for (const i in otherChains) {
                const tx = await service.populateTransaction.deployRemoteCanonicalToken(tokenId, otherChains[i], gasValues[i]);
                data.push(tx.data);
                value += gasValues[i];
            }

            const params = defaultAbiCoder.encode(['bytes', 'address'], ['0x', token.address]);
            const payload = defaultAbiCoder.encode(
                ['uint256', 'bytes32', 'string', 'string', 'uint8', 'bytes', 'bytes', 'uint256', 'bytes'],
                [SELECTOR_DEPLOY_AND_REGISTER_STANDARDIZED_TOKEN, tokenId, name, symbol, decimals, '0x', '0x', 0, '0x'],
            );
            await expect(service.multicall(data, { value }))
                .to.emit(service, 'TokenManagerDeployed')
                .withArgs(tokenId, LOCK_UNLOCK, params)
                .and.to.emit(service, 'RemoteStandardizedTokenAndManagerDeploymentInitialized')
                .withArgs(tokenId, name, symbol, decimals, '0x', '0x', 0, '0x', otherChains[0], gasValues[0])
                .and.to.emit(gasService, 'NativeGasPaidForContractCall')
                .withArgs(service.address, otherChains[0], service.address.toLowerCase(), keccak256(payload), gasValues[0], wallet.address)
                .and.to.emit(gateway, 'ContractCall')
                .withArgs(service.address, otherChains[0], service.address.toLowerCase(), keccak256(payload), payload)
                .and.to.emit(service, 'RemoteStandardizedTokenAndManagerDeploymentInitialized')
                .withArgs(tokenId, name, symbol, decimals, '0x', '0x', 0, '0x', otherChains[1], gasValues[1])
                .and.to.emit(gasService, 'NativeGasPaidForContractCall')
                .withArgs(service.address, otherChains[1], service.address.toLowerCase(), keccak256(payload), gasValues[1], wallet.address)
                .and.to.emit(gateway, 'ContractCall')
                .withArgs(service.address, otherChains[1], service.address.toLowerCase(), keccak256(payload), payload);
        });

        it('Should send some token to another chain', async () => {
            const amount = 1234;
            const destAddress = '0x1234';
            const destChain = otherChains[0];
            const gasValue = 6789;

            const payload = defaultAbiCoder.encode(
                ['uint256', 'bytes32', 'bytes', 'uint256'],
                [SELECTOR_SEND_TOKEN, tokenId, destAddress, amount],
            );
            const payloadHash = keccak256(payload);

            await expect(token.approve(tokenManager.address, amount))
                .to.emit(token, 'Approval')
                .withArgs(wallet.address, tokenManager.address, amount);

            await expect(tokenManager.sendToken(destChain, destAddress, amount, '0x', { value: gasValue }))
                .and.to.emit(token, 'Transfer')
                .withArgs(wallet.address, tokenManager.address, amount)
                .and.to.emit(gateway, 'ContractCall')
                .withArgs(service.address, destChain, service.address.toLowerCase(), payloadHash, payload)
                .and.to.emit(gasService, 'NativeGasPaidForContractCall')
                .withArgs(service.address, destChain, service.address.toLowerCase(), payloadHash, gasValue, wallet.address)
                .to.emit(service, 'TokenSent')
                .withArgs(tokenId, destChain, destAddress, amount);
        });

        // For this test the token must be a standardized token (or a distributable token in general)
        it('Should be able to change the token distributor', async () => {
            const newAddress = new Wallet(getRandomBytes32()).address;
            const amount = 1234;

            await expect(token.mint(newAddress, amount)).to.emit(token, 'Transfer').withArgs(AddressZero, newAddress, amount);
            await expect(token.burn(newAddress, amount)).to.emit(token, 'Transfer').withArgs(newAddress, AddressZero, amount);

            await expect(token.transferDistributorship(newAddress)).to.emit(token, 'DistributorshipTransferred').withArgs(newAddress);

            await expect(token.mint(newAddress, amount)).to.be.revertedWithCustomError(token, 'NotDistributor');
            await expect(token.burn(newAddress, amount)).to.be.revertedWithCustomError(token, 'NotDistributor');
        });
    });

    describe('Full standardized token registration, remote deployment and token send', async () => {
        let token;
        let tokenId;
        const salt = getRandomBytes32();
        const otherChains = ['chain 1', 'chain 2'];
        const gasValues = [1234, 5678];
        const tokenCap = BigInt(1e18);

        before(async () => {
            tokenId = await service.getCustomTokenId(wallet.address, salt);
            const tokenAddress = await service.getStandardizedTokenAddress(tokenId);
            token = new Contract(tokenAddress, IStandardizedToken.abi, wallet);
            const tokenManagerAddress = await service.getTokenManagerAddress(tokenId);
            tokenManager = new Contract(tokenManagerAddress, ITokenManager.abi, wallet);
        });

        it('Should register the token and initiate its deployment on other chains', async () => {
            const tx1 = await service.populateTransaction.deployAndRegisterStandardizedToken(
                salt,
                name,
                symbol,
                decimals,
                tokenCap,
                wallet.address,
            );
            const data = [tx1.data];
            let value = 0;

            for (const i in otherChains) {
                const tx = await service.populateTransaction.deployAndRegisterRemoteStandardizedToken(
                    salt,
                    name,
                    symbol,
                    decimals,
                    '0x',
                    '0x',
                    0,
                    wallet.address,
                    otherChains[i],
                    gasValues[i],
                );
                data.push(tx.data);
                value += gasValues[i];
            }

            const params = defaultAbiCoder.encode(['bytes', 'address'], [wallet.address, token.address]);
            const payload = defaultAbiCoder.encode(
                ['uint256', 'bytes32', 'string', 'string', 'uint8', 'bytes', 'bytes', 'uint256', 'bytes'],
                [SELECTOR_DEPLOY_AND_REGISTER_STANDARDIZED_TOKEN, tokenId, name, symbol, decimals, '0x', '0x', 0, wallet.address],
            );
            const tx = service.multicall(data, { value });

            await expect(tx)
                .to.emit(service, 'StandardizedTokenDeployed')
                .withArgs(tokenId, wallet.address, name, symbol, decimals, tokenCap, wallet.address)
                .and.to.emit(service, 'TokenManagerDeployed')
                .withArgs(tokenId, MINT_BURN, params)
                .and.to.emit(service, 'RemoteStandardizedTokenAndManagerDeploymentInitialized')
                .withArgs(tokenId, name, symbol, decimals, '0x', '0x', 0, wallet.address.toLowerCase(), otherChains[0], gasValues[0])
                .and.to.emit(gasService, 'NativeGasPaidForContractCall')
                .withArgs(service.address, otherChains[0], service.address.toLowerCase(), keccak256(payload), gasValues[0], wallet.address)
                .and.to.emit(gateway, 'ContractCall')
                .withArgs(service.address, otherChains[0], service.address.toLowerCase(), keccak256(payload), payload)
                .and.to.emit(service, 'RemoteStandardizedTokenAndManagerDeploymentInitialized')
                .withArgs(tokenId, name, symbol, decimals, '0x', '0x', 0, wallet.address.toLowerCase(), otherChains[1], gasValues[1])
                .and.to.emit(gasService, 'NativeGasPaidForContractCall')
                .withArgs(service.address, otherChains[1], service.address.toLowerCase(), keccak256(payload), gasValues[1], wallet.address)
                .and.to.emit(gateway, 'ContractCall')
                .withArgs(service.address, otherChains[1], service.address.toLowerCase(), keccak256(payload), payload);
        });

        it('Should send some token to another chain', async () => {
            const amount = 1234;
            const destAddress = '0x1234';
            const destChain = otherChains[0];
            const gasValue = 6789;

            const payload = defaultAbiCoder.encode(
                ['uint256', 'bytes32', 'bytes', 'uint256'],
                [SELECTOR_SEND_TOKEN, tokenId, destAddress, amount],
            );
            const payloadHash = keccak256(payload);

            await expect(tokenManager.sendToken(destChain, destAddress, amount, '0x', { value: gasValue }))
                .and.to.emit(token, 'Transfer')
                .withArgs(wallet.address, AddressZero, amount)
                .and.to.emit(gateway, 'ContractCall')
                .withArgs(service.address, destChain, service.address.toLowerCase(), payloadHash, payload)
                .and.to.emit(gasService, 'NativeGasPaidForContractCall')
                .withArgs(service.address, destChain, service.address.toLowerCase(), payloadHash, gasValue, wallet.address)
                .to.emit(service, 'TokenSent')
                .withArgs(tokenId, destChain, destAddress, amount);
        });

        // For this test the token must be a standardized token (or a distributable token in general)
        it('Should be able to change the token distributor', async () => {
            const newAddress = new Wallet(getRandomBytes32()).address;
            const amount = 1234;

            await expect(token.mint(newAddress, amount)).to.emit(token, 'Transfer').withArgs(AddressZero, newAddress, amount);
            await expect(token.burn(newAddress, amount)).to.emit(token, 'Transfer').withArgs(newAddress, AddressZero, amount);

            await expect(token.transferDistributorship(newAddress)).to.emit(token, 'DistributorshipTransferred').withArgs(newAddress);

            await expect(token.mint(newAddress, amount)).to.be.revertedWithCustomError(token, 'NotDistributor');
            await expect(token.burn(newAddress, amount)).to.be.revertedWithCustomError(token, 'NotDistributor');
        });
    });
});
