// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IPoolManager} from 'v4-core/interfaces/IPoolManager.sol';
import {IHooks} from 'v4-core/interfaces/IHooks.sol';
import {CurrencyLibrary, Currency} from 'v4-core/types/Currency.sol';
import {PoolKey} from 'v4-core/types/PoolKey.sol';
import {PoolId, PoolIdLibrary} from 'v4-core/types/PoolId.sol';
import {IPositionManager} from 'v4-periphery/src/PositionManager.sol';
import {IPoolInitializer_v4} from "v4-periphery/src/interfaces/IPoolInitializer_v4.sol";
import {Actions} from 'v4-periphery/src/libraries/Actions.sol';
import {LiquidityAmounts} from 'v4-periphery/src/libraries/LiquidityAmounts.sol';
import {TickMath} from 'v4-core/libraries/TickMath.sol';
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IAllowanceTransfer} from "permit2/src/interfaces/IPermit2.sol";

contract PoolTracker {
    using PoolIdLibrary for PoolKey;
    using CurrencyLibrary for Currency;

    // events
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

    // state
    IPoolManager public immutable poolManager;
    IPositionManager public immutable posm;
    IAllowanceTransfer public immutable permit2;

    mapping(PoolId => PoolKey) public trackedPools;
    uint256 public poolCount;

    // constructor
    constructor(
        IPoolManager _poolManager, 
        IPositionManager _posm,
        IAllowanceTransfer _permit2
    ) {
        poolManager = _poolManager;
        posm = _posm;
        permit2 = _permit2;
    }

    // external functions
    function initializeAndAddLiquidity(
        Currency currency0,
        Currency currency1,
        uint24 fee,
        int24 tickSpacing,
        IHooks hooks,
        uint160 sqrtPriceX96,
        int24 tickLower,
        int24 tickUpper,
        uint256 liquidity,
        uint128 amount0Max,
        uint128 amount1Max,
        address recipient,
        bytes calldata hookData,
        uint256 deadline
    ) external returns (int24 tick) {
        require(Currency.unwrap(currency0) < Currency.unwrap(currency1), "Token 0 must be < Token 1");

        // setup pool key
        PoolKey memory poolKey = PoolKey({
            currency0: currency0,
            currency1: currency1,
            fee: fee,
            tickSpacing: tickSpacing,
            hooks: hooks
        });

        // setup mint params
        (bytes memory actions, bytes[] memory mintParams) = 
            _mintParams(poolKey, tickLower, tickUpper, liquidity, amount0Max, amount1Max, recipient, hookData);

        // setup multicall params
        bytes[] memory params = new bytes[](2);
        params[0] = abi.encodeWithSelector(
            IPoolInitializer_v4.initializePool.selector,
            poolKey,
            sqrtPriceX96,
            hookData
        );
        params[1] = abi.encodeWithSelector(
            posm.modifyLiquidities.selector,
            abi.encode(actions, mintParams),
            block.timestamp + deadline
        );

        // check if using native eth
        uint256 valueToPass = currency0.isAddressZero() ? amount0Max : 0; // note no SWEEPING is done here, could be excess ETH

        // token approvals
        tokenApprovals(poolKey);

        // multicall uniswap v4 contract
        bytes[] memory results = posm.multicall{value: valueToPass}(params);
        
        // pool tracking
        tick = abi.decode(results[0], (int24));
        PoolId id = poolKey.toId();
        trackedPools[id] = poolKey;
        poolCount++;

        emit Initialize(
            id,
            poolKey.currency0,
            poolKey.currency1,
            poolKey.fee,
            poolKey.tickSpacing,
            poolKey.hooks,
            sqrtPriceX96,
            tick
        );
    }

    function _mintParams(
        PoolKey memory poolKey,
        int24 tickLower,
        int24 tickUpper,
        uint256 liquidity,
        uint256 amount0Max,
        uint256 amount1Max,
        address recipient,
        bytes calldata hookData
    ) internal pure returns (bytes memory, bytes[] memory) {
        bytes memory actions = abi.encodePacked(
            uint8(Actions.MINT_POSITION), 
            uint8(Actions.SETTLE_PAIR)
        );

        bytes[] memory mintParams = new bytes[](2);
        mintParams[0] = abi.encode(poolKey, tickLower, tickUpper, liquidity, amount0Max, amount1Max, recipient, hookData);
        mintParams[1] = abi.encode(poolKey.currency0, poolKey.currency1);

        return (actions, mintParams);
    }

    function tokenApprovals(PoolKey memory poolKey) public {
        address token0 = Currency.unwrap(poolKey.currency0);
        address token1 = Currency.unwrap(poolKey.currency1);

        if (!poolKey.currency0.isAddressZero()) {
            IERC20(token0).approve(address(permit2), type(uint256).max);
            permit2.approve(token0, address(posm), type(uint160).max, type(uint48).max);
        }
        if (!poolKey.currency1.isAddressZero()) {
            IERC20(token1).approve(address(permit2), type(uint256).max);
            permit2.approve(token1, address(posm), type(uint160).max, type(uint48).max);
        }
    }

    // Single pool query - gas efficient
    function getPoolKey(PoolId poolId) external view returns (PoolKey memory) {
        return trackedPools[poolId];
    }
}