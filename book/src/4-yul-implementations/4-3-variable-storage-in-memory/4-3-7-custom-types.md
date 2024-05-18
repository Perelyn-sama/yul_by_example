# Custom Types

Custom types behave like their underlying types.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    type Address is address;

    function addressInMemory(Address value) public pure returns (bytes32) {
        assembly {
            mstore(0x80, value)
            return(0x80, 0x20)
        }
    }
}
```