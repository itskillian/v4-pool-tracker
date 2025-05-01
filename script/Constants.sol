// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";
import {IPositionManager} from "v4-periphery/src/PositionManager.sol";
import {IAllowanceTransfer} from "permit2/src/interfaces/IAllowanceTransfer.sol";

/// @notice Shared constants used in scripts
contract Constants {

    // Mainnet addresses
    IPoolManager constant POOLMANAGER_MAINNET = IPoolManager(address(0x000000000004444c5dc75cB358380D2e3dE08A90));
    IPositionManager constant POSM_MAINNET = IPositionManager(address(0xbD216513d74C8cf14cf4747E6AaA6420FF64ee9e));
    IAllowanceTransfer constant PERMIT2_MAINNET = IAllowanceTransfer(address(0x000000000022D473030F116dDEE9F6B43aC78BA3));

    // Sepolia addresses
    IPoolManager constant POOLMANAGER_SEPOLIA = IPoolManager(address(0xE03A1074c86CFeDd5C142C4F04F1a1536e203543));
    IPositionManager constant POSM_SEPOLIA = IPositionManager(address(0x429ba70129df741B2Ca2a85BC3A2a3328e5c09b4));
    IAllowanceTransfer constant PERMIT2_SEPOLIA = IAllowanceTransfer(address(0x000000000022D473030F116dDEE9F6B43aC78BA3));

    // Unichain addresses
    IPoolManager constant POOLMANAGER_UNICHAIN = IPoolManager(address(0x1F98400000000000000000000000000000000004));
    IPositionManager constant POSM_UNICHAIN = IPositionManager(address(0x4529A01c7A0410167c5740C487A8DE60232617bf));
    IAllowanceTransfer constant PERMIT2_UNICHAIN = IAllowanceTransfer(address(0x000000000022D473030F116dDEE9F6B43aC78BA3));

    // Unichain Sepolia addresses
    IPoolManager constant POOLMANAGER_UNICHAIN_SEPOLIA = IPoolManager(address(0x00B036B58a818B1BC34d502D3fE730Db729e62AC));
    IPositionManager constant POSM_UNICHAIN_SEPOLIA = IPositionManager(address(0xf969Aee60879C54bAAed9F3eD26147Db216Fd664));
    IAllowanceTransfer constant PERMIT2_UNICHAIN_SEPOLIA = IAllowanceTransfer(address(0x000000000022D473030F116dDEE9F6B43aC78BA3));
}