# `mapping`

---

A typical `mapping` in Solidity is accessed using the `key`. There are two types of `mapping` as you know, single 
`mapping` and nested `mapping`. We will look at how to retrieve data from a single and a nested `mapping`.

### Single `mapping`
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    mapping(address => uint256) public myMap;
    
    function getMap() public view returns (uint256) {
        return myMap[msg.sender];
    }
}
```

In the `getMap` function, the `msg.sender` is the key.

In Yul, `mappings` take up a full slot. They cannot be packed with any other variable. And to access a `mapping` `key` 
value, the value is stored at a location calculated as the `keccak256(key, slot)`. In other words, to access the 
value of a `key` in a `mapping`, we must know the corresponding `slot` of the `mapping`, and the `key` we want to look for. 
Then, we store the `key` first in the first 32 bytes of free memory, and store the `slot` in the next 32 bytes of free 
memory, and then hash the entire thing from the start of the first memory containing the `key` to the end of the 
second memory containing the `slot`. This will always be a constant size of `64 bytes`, `0x40` in hexadecimals.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    uint64 public TIME = uint64(block.timestamp);   // Slot 0.
    mapping(address => uint256) public myMap;       // Slot 1.

    constructor() {
        myMap[msg.sender] = TIME;
    }

    function getMap() public view returns (bytes32) {
        assembly {
            // Get free memory location.
            let freeMemLoc := mload(0x40)
            // Store our key, `msg.sender` at the free memory.
            mstore(freeMemLoc, caller())
            // Set the next free memory to be the start of the next 32-byte slot location,
            // as we've stored the `msg.sender` in the current freeMemLoc location.
            let nextFreeMemLoc := add(freeMemLoc, 0x20)
            // Store the slot of the mapping (1) in the next free memory location.
            mstore(nextFreeMemLoc, 0x01)
            // Hash from start to end.
            let keyLocation := keccak256(freeMemLoc, 0x40)
            // Get the value of the key in the mapping.
            let value := sload(keyLocation)

            // Store value in memory and return.
            mstore(0x80, value)
            return(0x80, 0x20)
        }
    }
}
```

### Nested `mapping`
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    mapping(address => mapping(uint256 => uint256)) public myNestedMap;
    
    function getMap(uint256 index) public view returns (uint256) {
        return myNestedMap[msg.sender][index];
    }
}
```

A nested `mapping` can have two or more keys.

To load data from a nested mapping, the number of hashes to be done must be equal to the number of keys in the map. 
As we saw earlier, our previous single mapping had one key, and we did only one hash. A mapping with two keys will 
require two hashes to get to the part of storage holding its value. The first hash, would be exactly as the one 
above where we hash a memory concatenation of the first key and the slot. The corresponding hashes would be a 
concatenation of the next key and the hash value of the previous hash.

Let us see what we mean. We will try to store a number on index `5` of the `msg.sender` and we will retrieve it using 
Yul.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    uint8 public INDEX = 5;                                             // Slot 0.
    uint64 public TIME = uint64(block.timestamp);                       // Slot 0.
    mapping(address => mapping(uint256 => uint256)) public myNestedMap; // Slot 1.

    constructor() {
        myNestedMap[msg.sender][INDEX] = TIME;
    }
    
    function getNestedMap() public view returns (bytes32) {
        assembly {
            // Get free memory location.
            let freeMemLoc := mload(0x40)
            // Store our first key, `msg.sender` at the free memory.
            mstore(freeMemLoc, caller())
            // Set the next free memory to be the start of the next 32-byte slot location,
            // as we've stored the `msg.sender` in the current freeMemLoc location.
            let nextFreeMemLoc := add(freeMemLoc, 0x20)
            // Store the slot of the mapping (1) in the next free memory location.
            mstore(nextFreeMemLoc, 0x01)
            // Hash from start to end.
            let innerHash := keccak256(freeMemLoc, 0x40)
            // This is the first hash retrieved. To get the actual location, there
            // will be a second hash.
            // We simply repeat the process as above, only concatenating the next
            // key and the previous hash value.
            // INDEX == 5, `0x05` in hexadecimal.
            mstore(freeMemLoc, 0x05)
            mstore(nextFreeMemLoc, innerHash)
            let location := keccak256(freeMemLoc, 0x40)
            // Get the value of the key in the mapping.
            let value := sload(location)

            // Store value in memory and return.
            mstore(0x80, value)
            return(0x80, 0x20)
        }
    }
}
```

Depending on how many keys are in your nested mapping, you simply have to repeat the entire process.