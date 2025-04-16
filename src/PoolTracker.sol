// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IPoolManager} from 'v4-core/interfaces/IPoolManager.sol';
import {IHooks} from 'v4-core/interfaces/IHooks.sol';
import {Currency} from 'v4-core/types/Currency.sol';
import {PoolKey} from 'v4-core/types/PoolKey.sol';
import {PoolId, PoolIdLibrary} from 'v4-core/types/PoolId.sol';

contract PoolTracker {
    using PoolIdLibrary for PoolKey;

    event Initialize(
        PoolId indexed id,
        Currency indexed currency0,
        Currency indexed currency1,
        uint24 fee,
        int24 tickSpacing,
        IHooks hooks,
        uint160 sqrtPriceX96,
        int24 tick
    );
    
    IPoolManager public immutable poolManager;

    mapping(PoolId => PoolKey) public trackedPools;
    uint256 public poolCount;

    constructor(IPoolManager _poolManager) {
        poolManager = _poolManager;
    }

    function initialize(
        PoolKey memory key,
        uint160 sqrtPriceX96
    ) public returns (int24 tick) {
        PoolId id = key.toId();
        trackedPools[id] = key;
        poolCount++;

        tick = poolManager.initialize(key, sqrtPriceX96);

        emit Initialize(
            id,
            key.currency0,
            key.currency1,
            key.fee,
            key.tickSpacing,
            key.hooks,
            sqrtPriceX96,
            tick
        );
    }

    // Single pool query - gas efficient
    function getPoolKey(PoolId poolId) external view returns (PoolKey memory) {
        return trackedPools[poolId];
    }
}