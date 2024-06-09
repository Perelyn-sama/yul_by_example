# `address`

---

The storage of `address` in memory are very simple, they are written directly at our chosen memory location and are returned the same.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function addressInMemory(address value) public pure returns (bytes32) {
        assembly {
            mstore(0x80, value)
            return(0x80, 0x20)
        }
    }
}
```
