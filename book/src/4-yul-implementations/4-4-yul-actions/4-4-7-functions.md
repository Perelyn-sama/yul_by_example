# Functions

Functions are declared by the `function` keyword. And they are of two types, functions with return values and those without.

## Functions without a return value.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function fnWithoutReturn(uint256 a, uint256 b) public pure returns (uint256) {
        assembly {
            function sum(num1, num2) {
                mstore(0x80, add(num1, num2))
            }
            
            sum(a, b)
            return(0x80, 0x20)
        }
    }
}
```

## Functions without a return value.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function fnWithReturn(uint256 a, uint256 b) public pure returns (uint256) {
        assembly {
            function sum(num1, num2) -> total {
                total := add(num1, num2)
            }
            
            mstore(0x80, sum(a, b))
            return(0x80, 0x20)
        }
    }
}
```