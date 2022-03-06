// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.4;

import "./interfaces/ILayerZeroReceiver.sol";
import "./interfaces/ILayerZeroEndpoint.sol";

// A classic "counter" example
// Deploy two instances of this contract and call incrementCounter() to increment the messageCounter on the destination contract
contract MultiChainCounter is ILayerZeroReceiver {
    // keep track of how many messages have been received from other chains
    uint256 public messageCounter;

    // required: the LayerZero endpoint which is passed in the constructor
    ILayerZeroEndpoint public endpoint;

    // required: the LayerZero endpoint
    constructor(address _endpoint) {
        endpoint = ILayerZeroEndpoint(_endpoint);
    }

    // overrides lzReceive function in ILayerZeroReceiver
    // automatically invoked on the receiving chain after the source chain calls endpoint.send()

    // LayerZero endpoint will invoke this function to deliver the message on the destination
    // @param _srcChainId - the source endpoint identifier
    // @param _srcAddress - the source sending contract address from the source chain
    // @param _nonce - the ordered message nonce
    // @param _payload - the signed payload is the UA bytes has encoded to be sent
    function lzReceive(
        uint16,
        bytes memory,
        uint64,
        bytes memory
    ) external override {
        require(msg.sender == address(endpoint));
        messageCounter += 1;
    }

    // custom function that wraps endpoint.send() which will cause lzReceive() to be called on the destination chain
    function incrementCounter(
        uint16 _dstChainId,
        bytes calldata _dstCounterMockAddress
    ) public payable {
        // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
        // @param _chainId - the destination chain identifier
        // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
        // @param _payload - a custom bytes payload to send to the destination contract
        // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
        // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
        // @param _adapterParams - parameters for custom functionality. ie: pay for a specified destination gasAmount, or receive airdropped native gas from the relayer on destination (oh yea!)
        endpoint.send{value: msg.value}(
            _dstChainId,
            _dstCounterMockAddress,
            bytes(""),
            payable(msg.sender),
            address(0x0),
            bytes("")
        );
    }
}
