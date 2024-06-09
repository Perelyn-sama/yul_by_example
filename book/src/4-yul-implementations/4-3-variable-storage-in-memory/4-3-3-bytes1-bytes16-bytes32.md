# `bytes1`, `bytes16`, `bytes32`

---

The storage of `bytes1`, `bytes16`, `bytes32` in memory are quite different, they are right-padded to 32 bytes if they're not up to 32 bytes, and then,  they are written directly at our chosen memory location and are returned with the padding.

## Padding?

Padding is the process of adding  a number of `0` to a data type's hexadecimal value to make it up to 32 bytes so that it can be written to a location in storage or memory. If the value is up to 32 bytes, it is not padded.

As you must've observed:
- `bytes[n]` data written directly to storage from the global variable declaration are left padded, `0x<00..00><value>`.
- `bytes[n]` data written directly to storage from Yul are left padded, `0x<00..00><value>`.
- `bytes[n]` data written directly to memory from the global variable declaration are left padded, `0x<00..00><value>`.
- `bytes[n]` data written directly to memory from Yul are left padded, `0x<00..00><value>`.

---

- `bytes[n]` data declared inside a function body and then written to storage are right padded, `0x<value><00..00>`.
- `bytes[n]` data declared as a function parameter and then written to memory are right padded, `0x<value><00..00>`.
- `bytes[n]` data declared as a `constant` and then written to memory are right padded, `0x<value><00..00>`.

---

- Everything else is left padded.

> 😉 Keep the above in mind.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function bytes1InMemory(bytes1 value) public pure returns (bytes32) {
        assembly {
            mstore(0x80, value)
            return(0x80, 0x20)
        }
    }

    function bytes16InMemory(bytes16 value) public pure returns (bytes32) {
        assembly {
            mstore(0x80, value)
            return(0x80, 0x20)
        }
    }

    function bytes32InMemory(bytes32 value) public pure returns (bytes32) {
        assembly {
            mstore(0x80, value)
            return(0x80, 0x20)
        }
    }
}
```
> 😉 Everything returned here will be right padded, `0x<value><00..00>`.