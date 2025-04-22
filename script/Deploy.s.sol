// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {PoolTracker} from "../../src/PoolTracker.sol";
import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";
import {IPositionManager} from "v4-periphery/src/PositionManager.sol";
import {IAllowanceTransfer} from "permit2/src/interfaces/IPermit2.sol";
import {Constants} from "./Constants.sol";

contract DeployPoolTrackerScript is Script, Constants {
    PoolTracker public poolTracker;
    
    IPoolManager poolManager;
    IPositionManager posm;
    IAllowanceTransfer permit2;

    function setUp() public {
        // Get the chain ID
        uint256 chainId = block.chainid;

        // Set the appropriate addresses based on the chain
        if (chainId == 1) { // Mainnet
            poolManager = POOLMANAGER_MAINNET;
            posm = POSM_MAINNET;
            permit2 = PERMIT2_MAINNET;
        } else if (chainId == 11155111) { // Sepolia
            poolManager = POOLMANAGER_SEPOLIA;
            posm = POSM_SEPOLIA;
            permit2 = PERMIT2_SEPOLIA;
        } else {
            revert("Unsupported chain ID");
        }
    }
    
    function run() public {
        setUp();
        
        console.log("Deploying PoolTracker on chain ID:", block.chainid);
        console.log("Using PoolManager:", address(poolManager));
        console.log("Using PositionManager:", address(posm));
        console.log("Using Permit2:", address(permit2));
        
        vm.startBroadcast();
        poolTracker = new PoolTracker(poolManager, posm, permit2);
        console.log("Deployed PoolTracker at:", address(poolTracker));
        vm.stopBroadcast();
    }
}