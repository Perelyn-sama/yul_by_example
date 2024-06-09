# Loops

---

Yul only has `for` loops. There exists no `while` loops in Yul.

## `for` Loops

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function forLoop() public pure returns (bytes32) {
        assembly {
            let x := 0
            for { let i := 0 } lt(i, 10) { i := add(i, 1) } {
                x := add(x, 1)
                if eq(x, 5) { continue } // Skip value.

                // This will not run because 5 is skipped.
                if eq(x, 5) { break } // Stop loop.
                
                if eq(x, 10) { break }
            }
            
            mstore(0x80, x)
            return(0x80, 0x20)
        }
    }
}
```

## `while` Loops

To make a `for` loop act like a `while` loop, this is how we do it.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function whileLoop() public pure returns (bytes32) {
        assembly {
            let x := 0
            for { } lt(x, 10) { } {
                x := add(x, 1)
            }
            
            mstore(0x80, x)
            return(0x80, 0x20)
        }
    }
}
```

## Infinite Loops

To achieve the behaviour of an infinite loop, an approach to the `for` loop is used.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function infiniteLoop() public pure returns (bytes32) {
        assembly {
            let x := 0
            for { } 1 { } {
                x := add(x, 1)
            }
            
            mstore(0x80, x)
            return(0x80, 0x20)
        }
    }
}
```