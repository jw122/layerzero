# LayerZero
Experiments with [LayerZero](https://github.com/LayerZero-Labs), the protocol for cross-chain messaging


## MultiChainCounter
Source: https://github.com/LayerZero-Labs/solidity-examples

This is a classic example of a simple contract implementing a counter, but on another chain.

The `MultiChainCounter` contract can send and receive LayerZero messages. This contract has to be deployed on both the source chain and the destination chain. I attempted this with testnets on Ethereum (Rinkeby) and Polygon (Mumbai).

Making use of LayerZero involves implementing a way to call `send()` and `lzReceive()`

Every contract is a `ILayerZeroReceiver`

### Sending a message from Chain A

To send a message a message, we call the `endpoint.send()` function from the source chain:
    
```
endpoint.send{value:msg.value}(10001, destUaAddr, bytes("hello"), msg.sender, address(this), bytes(""));
```
`send()` has a few parameters: destination chainId, destination contract address, raw bytes of payload, where additional destination gas is refunded, address, tx parameters)

### Receiving a message from Chain B
Your User Application contract must override the `lzReceive()` function. Any logic can be executed on the receiving chain.

The destination chain will execute `lzReceive` to receive the message.

### Testing
I deployed contracts using REMIX. Had to include the interfaces as well, which get imported in `MultiCoinCounter.sol`

You must deploy the contract with an Endpoint address.
An **endpoint** is the main LayerZero contract you interact with. An instance of `Endpoint.sol` is used to send messages to another chain via the `endpoint.send()` function.

See addresses for [testnet](https://layerzero.gitbook.io/docs/technical-reference/testnet/contract-addresses#layerzero-endpoints-testnet)

### Contracts deployed:
Polygon (Mumbai): [https://mumbai.polygonscan.com/address/0x57d2cf90ddce622fd98677db36d1a7051d991070](https://mumbai.polygonscan.com/address/0x57d2cf90ddce622fd98677db36d1a7051d991070)

Ethereum (rinkeby): [https://rinkeby.etherscan.io/address/0x9e799d14d9b042f1e9a85e66e7eb38affe16045b](https://rinkeby.etherscan.io/address/0x9e799d14d9b042f1e9a85e66e7eb38affe16045b)

You can load in these contracts from REMIX, and trigger the functions manually using injected Web3 (MetaMask).