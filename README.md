### Addresses
Deployer: `0xb3071bc8838cab347BE299C42F8EDD0fb484D946`
Sepolia Contract: `0x5b2B598f436c4A69266BD03a6aF3A45b69e376c6`

# Commands
### Build
```shell
$ forge build --via-ir
```

### Cast
```bash
source .env

cast wallet list

cast wallet address --account DEPLOYER

cast balance --rpc-url $SEPOLIA_RPC_URL 0xb3071bc8838cab347BE299C42F8EDD0fb484D946
```
- Replace with `$MAINNET_RPC_URL` for mainnet

### Deploy scripts
See `script/Constants.sol` for constructor addresses by chain

Sepolia:
```bash
source .env
forge script --chain sepolia script/Deploy.s.sol:DeployPoolTrackerScript --rpc-url $SEPOLIA_RPC_URL --account DEPLOYER --broadcast --via-ir --verify
```
Mainnet:
```bash
source .env
forge script --chain mainnet script/Deploy.s.sol:DeployPoolTrackerScript --rpc-url $MAINNET_RPC_URL --account DEPLOYER --broadcast --via-ir --verify
```

Unichain:
```bash
source .env
forge script --chain-id 130 script/Deploy.s.sol:DeployPoolTrackerScript --rpc-url $UNICHAIN_RPC_URL --account DEPLOYER --broadcast --via-ir --verify
```

Unichain Sepolia:
```bash
source .env
forge script --chain unichain-sepolia script/Deploy.s.sol:DeployPoolTrackerScript --rpc-url $UNICHAIN_SEPOLIA_RPC_URL --account DEPLOYER --broadcast --via-ir --verify
```

### Test
TODO
```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

### Verify

```bash
$ forge verify-contract --chain-id <chain-id> <contract-address> src/PoolTracker.sol:PoolTracker
```
