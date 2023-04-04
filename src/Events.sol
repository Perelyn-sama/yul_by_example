// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract Events {
    event IndexedEvent(address indexed a, uint256 indexed b);
    event NonIndexedEvent(uint256 a, uint256 b);
    event MixedEvent(address indexed a, address b);

    bytes32 constant IndexedEventTopic = 0xfdcfbb6e25802e9ba4d7c62d4a85a10e40219c69383d35be084b401980dd7156;
    bytes32 constant NonIndexedEventTopic = 0x8a2dba84c9d33350ff3006c2607aae76d062ae5ac6632d800030613bcf7f74a0;
    bytes32 constant MixedEventTopic = 0x4064e2ecc8fd7344e5a93edd930ffb63eef7a4ce03792d11d64508b29ec3b7be;

    function emitIndexedEvent(uint256 x) public {
        assembly {
            log3(0x00, 0x00, IndexedEventTopic, caller(), x)
        }
    }

    function emitNonIndexedEvent(uint256 a, uint256 b) public {
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            log1(0x00, 0x40, NonIndexedEventTopic)
        }
    }

    function emitMixedEvent(address a) public {
        assembly {
            mstore(0x00, a)
            log2(0x00, 0x20, MixedEventTopic, caller())
        }
    }
}