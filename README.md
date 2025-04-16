# Commands

### Build
```shell
$ forge build
```

### Check balance
```bash
cast balance --rpc-url $SEPOLIA_RPC_URL 0xb3071bc8838cab347BE299C42F8EDD0fb484D946
```
- Replace with `$MAINNET_RPC_URL` for mainnet

### Test

```shell
$ forge test
```

### Deploy
Sepolia:
```bash
forge create ./src/PoolTracker.sol:PoolTracker --rpc-url $SEPOLIA_RPC_URL --account DEPLOYER --broadcast --constructor-args 0xE03A1074c86CFeDd5C142C4F04F1a1536e203543
```

Mainnet: 
```bash
forge create ./src/PoolTracker.sol:PoolTracker --constructor-args "0x000000000004444c5dc75cB358380D2e3dE08A90" --rpc-url $MAINNET_RPC_URL --account DEPLOYER
```

### Verify
Sepolia:
```bash
forge verify-contract <DEPLOYED_ADDRESS> ./src/PoolTracker.sol:PoolTracker --chain sepolia --watch --etherscan-api-key PT5B57P5F2G1FTE16J2SUTXJYQ1EUWVGFY --constructor-args $(cast abi-encode "constructor(address)" 0xE03A1074c86CFeDd5C142C4F04F1a1536e203543)
```
- remove `--chain sepolia` flag to default to mainnet

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
