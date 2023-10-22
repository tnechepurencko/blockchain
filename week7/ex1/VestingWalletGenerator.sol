// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (finance/VestingWallet.sol)

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/finance/VestingWallet.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VestingWalletGenerator is Ownable, VestingWallet {
    address payable manager;
    address payable wallet;

    constructor(address payable managerAddress, address payable walletAddress, uint64 duration) 
    VestingWallet(walletAddress, uint64(block.timestamp), duration) {
        manager = managerAddress;
        wallet = walletAddress;
    } 
    
    function withdraw() public {
        manager.transfer(wallet.balance);
    }
}

contract Management {
    address payable manager;
    address[] walletsAddresses;
    mapping(address => VestingWalletGenerator) public wallets;

    constructor() {
        manager = payable(msg.sender);
    }

    function createWallet(address payable employeeAddress, uint64 duration) public {
        require(msg.sender == manager);
        VestingWalletGenerator w = new VestingWalletGenerator(manager, employeeAddress, duration);
        wallets[employeeAddress] = w;
    }

    function addressExist(address employeeAddress) public view returns(bool) {
        for (uint i = 0; i < walletsAddresses.length; i++){
            if (walletsAddresses[i] == employeeAddress) {
                return true;
            }
        }

        return false;
    }

    function releaseToken() public {
        require(addressExist(msg.sender));
        delete wallets[msg.sender];
    }

    function retrieveWallets() public view returns (VestingWalletGenerator[] memory) {
        require(msg.sender == manager);
        VestingWalletGenerator[] memory walletsArray;

        for (uint i = 0; i < walletsAddresses.length; i++){
            walletsArray[i] = (wallets[walletsAddresses[i]]);
        }

        return walletsArray;
    }

    function withdraw(address employeeAddress) public {
        require(msg.sender == manager);
        wallets[employeeAddress].withdraw();
    }
}
