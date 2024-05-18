# Arrays

## Fixed Arrays, `<type>[n]`

The storage of fixed arrays in memory is simply a concatenation of the storage of its individual elements.

## Dynamic Arrays, `<type>[]`

This follows the three part of memory storage, the

1. The pointer.
2. The length.
3. The value.

By declaring the `<type>[] memory <variableName>`, `<variableName>` is the pointer. In memory, we can call `mload(<variableName>) `to load the pointer. The length of the array is stored in the `<variableName>` pointer. And we can then go over each 32 byte chunk as much as the length permits to get all values.

Let's take a look.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function addressInMemory(uint8[] memory values) public pure returns (bytes32) {
        assembly {
            mstore(0x80, mload(add(values, 0x20))) // First array value.
            return(0x80, 0x20)
        }
    }

    function addressInMemory2(uint8[] memory values) public pure returns (bytes32) {
        assembly {
            mstore(0x80, mload(add(values, 0x40))) // Second array value.
            return(0x80, 0x20)
        }
    }
}
```