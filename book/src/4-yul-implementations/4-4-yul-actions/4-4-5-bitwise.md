# Bitwise

---

Bitwise operations involve `left shift`, `right shift`, `and`, `or`, `xor` and `not`.

## Left Shift, `shl(a, b)`

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function shiftLeft(uint256 num, uint256 bitsToShift) public pure returns (bytes32) {
        assembly {
            mstore(0x80, shl(bitsToShift, num))
            return(0x80, 0x20)
        }
    }
}
```
`shl(a, b)` is a Yul function that takes in two arguments, `a`, the number of bits `b` would be shifted by, and `b`, the number to shift. It returns the new value which is the value returned by running `b << a`.

## Right Shift, `shr(a, b)`

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function shiftRight(uint256 num, uint256 bitsToShift) public pure returns (bytes32) {
        assembly {
            mstore(0x80, shr(bitsToShift, num))
            return(0x80, 0x20)
        }
    }
}
```

`shr(a, b)` is a Yul function that takes in two arguments, `a`, the number of bits `b` would be shifted by, and `b`, the number to shift. It returns the new value which is the value returned by running `b >> a`.

## And, `and(a, b)`

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function and(uint256 num, uint256 andNum) public pure returns (bytes32) {
        assembly {
            mstore(0x80, and(num, andNum))
            return(0x80, 0x20)
        }
    }
}
```

`and(a, b)` is a Yul function that takes in two numbers as arguments. It returns the new value which is the value returned by running `a && b`.

## Or, `or(a, b)`

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function or(uint256 num, uint256 orNum) public pure returns (bytes32) {
        assembly {
            mstore(0x80, or(num, orNum))
            return(0x80, 0x20)
        }
    }
}
```

`or(a, b)` is a Yul function that takes in two numbers as arguments. It returns the new value which is the value returned by running `a || b`.

## Xor, `xor(a, b)`

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function xor(uint256 num, uint256 xorNum) public pure returns (bytes32) {
        assembly {
            mstore(0x80, xor(num, xorNum))
            return(0x80, 0x20)
        }
    }
}
```

`xor(a, b)` is a Yul function that takes in two numbers as arguments. It returns the new value which is the value returned by running `a ^ b`.

## Not, `not(a)`

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function not(uint256 num) public pure returns (bytes32) {
        assembly {
            mstore(0x80, not(num))
            return(0x80, 0x20)
        }
    }
}
```

`not(a)` is a Yul function that takes in a number as argument. It returns the new value which is the value returned by running `~a`.