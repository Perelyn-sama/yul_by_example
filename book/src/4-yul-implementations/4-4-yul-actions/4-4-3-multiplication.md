# Multiplication


```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function multiply(uint256 x, uint256 y) public pure returns (bytes32) {
        assembly {
            mstore(0x80, mul(x, y))
            return(0x80, 0x20)
        }
    }
}
```

The `mul(a, b)` Yul command takes in two numbers as arguments and returns their product, `a * b`.

> 🚨 Multiplications in Yul are `unchecked`, meaning that, Yul wraps around numbers if they exceed the highest possible number to be stored in a slot.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function multiply() public pure returns (bytes32) {
        assembly {
            let large := 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
            mstore(0x80, mul(large, 0x12345678))
            return(0x80, 0x20)
        }
    }
}

```

The above will return `0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffedcba988` showing a wrap around.

To write a Yul multiplication code to check for overflows and prevent them, this will be the approach to use [[6](https://github.com/ConsenSysMesh/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol)].

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function multiply(uint256 x, uint256 y) public pure returns (bytes32) {
        assembly {
            if eq(x, 0) {
                return(0x80, 0x20)
            }

            if eq(y, 0) {
                return(0x80, 0x20)
            }

            let z := mul(x, y)
            if iszero(eq(div(z, x), y)) { revert(0x00, 0x00) }

            mstore(0x80, z)
            return(0x80, 0x20)
        }
    }
}
```

The `eq(a, b)` Yul function takes in two numbers as arguments and returns `1` meaning `true` if `a == b` and 
`0`meaning `false` if `a != b`. The `iszero(a)` function takes in one number as arguments and returns `1` if `a == 0` 
and `0` if `a = 0`. The `eq(a, b)` is used to check the `truthiness` of an expression, while, the `iszero(a)` is the 
method used to check the `falsiness` of an expression. The `revert(0x<a>, 0x<b>)` reverts the operation with some error 
message encoded according to the ABI Specification stored starting from positon `0x<a>` and spanning `0x<b>` bytes.