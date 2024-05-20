# Conditionals

These involve `if` and `switch` statements.

> There are no `else` statements in Yul.

## `if`

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    // Is x greater than or equal to 10?
    function ifElse(uint256 x) public pure returns (bytes32) {
        assembly {
            let res
            if lt(x, 10) { res := 0 }
            if eq(x, 10) { res := 1 }
            if gt(x, 10) { res := 1 }
            
            mstore(0x80, res)
            return(0x80, 0x20)
        }
    }
}
```

`lt(a, b)` returns true if `a < b`. `gt(a, b)` returns true if `a > b`. `eq(a, b)` returns true if `a == b`.

## `switch`

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    // Is x greater than or equal to 80?
    function switch(uint256 x) public pure returns (bytes32) {
        assembly {
            let isTrue
            
            switch gt(x, 79)
            case 1 { isTrue := 0x01 }
            default { isTrue := 0x00 }
            
            mstore(0x80, isTrue)
            return(0x80, 0x20)
        }
    }
}
```