# `string`

`string` is first converted into its `bytes` type by converting each individual ASCII character to its hexadecimal 
value. It is then stored in the exact way `bytes` are stored.

Example, a `string` type, `"hello"` would be first converted into `0x68656c6c6f`, a concatenation of each hexadecimal value of each character, and then stored just the way `bytes` are stored.

To get a knowledge of what the hexadecimal values of ASCII characters are, you can look up this table at 
[RapidTables.com](https://www.rapidtables.com/code/text/ascii-table.html).

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function stringInMemory(string memory value) public pure returns (bytes32) {
        assembly {
            let valueLoc := add(value, 0x20)
            let bytesValue := mload(valueLoc)
            mstore(0x80, bytesValue)
            return(0x80, 0x20)
        }
    }
}
```

Refer to [bytes](4-3-4-bytes.md).