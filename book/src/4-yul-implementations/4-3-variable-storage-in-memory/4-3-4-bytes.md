# `bytes`

---

The storage of `bytes` in memory is very tricky. Normally, declaring a `bytes` variable in memory will be followed by the `memory` keyword as in `bytes memory <variableName>` this is because, `bytes` values are encoded in memory. The encoding has three parts.

1. The pointer.
2. The length.
3. The value.

By declaring the `bytes memory <variableName>`, `<variableName>` is the pointer. In memory, we can call `mload(<variableName>) `to load the pointer. The length of the bytes value is stored in the `<variableName>` pointer. And the value is stored immediately after that. Therefore, reading the next memory chunk after the length chunk is the actual value, meaning that if we read location`<variableName> + 32 bytes` in memory, we get the actual value (If `<variableName>` is `0x20` in memory, it holds the length, and `0x40` will hold the value, `0x20` is 32 bytes). Using the length recovered from `mload(<variableName>)`, we can know how many bytes of data we can read from the value location.

To encode `bytes` in memory (or `calldata`), we need to know the length of the `bytes` to return. Then, we pick a part of memory we desire and take note of the location, let's call there `0xa0`. At memory location `0xa0`, we store `0x20`, this is the pointer. At the next 32 bytes, `0xc0`, we store the length of the bytes. And at the next 32 bytes, `0xe0`, we store the bytes value.

Finally, we return the data starting from 0xa0 where we started and reading 96 bytes. 96 bytes? Yes, `0xa0` to `0xbf` is 32 bytes holding our pointer, `0xc0` to `0xdf` is another 32 bytes holding our length, and `0xe0` to `0xff` another 32 bytes holding the data.

If the `bytes` value is greater than 32 bytes, we write to more locations after `0xe0` and read the corresponding size in bytes.

Declaring `bytes memory <variableName>` automatically creates a pointer and length for you depending on the value you pass as the value of the `variableName` variable. We can simply return whatever it is. The actual bytes value are written the same way in storage, `0x<value><00..00>`.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function bytesInMemory(bytes memory value) public pure returns (bytes32) {
        assembly {
            // Value is pointer.
            let valueLoc := add(value, 0x20)
            let bytesValue := mload(valueLoc)
            mstore(0x80, bytesValue)
            return(0x80, 0x20)
        }
    }
}
```