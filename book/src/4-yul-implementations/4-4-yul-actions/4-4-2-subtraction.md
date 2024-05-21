# Subtraction

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function subtract(uint256 x, uint256 y) public pure returns (bytes32) {
        assembly {
            mstore(0x80, sub(x, y))
            return(0x80, 0x20)
        }
    }
}
```

The `sub(a, b)` Yul function takes in two numbers as arguments and returns the difference between the two numbers, `a - b`.

> 🚨 Subtractions in Yul are `unchecked`, meaning that, Yul will also wrap around numbers if the result of the subtraction goes lower than the `0` when subtracting, that is if `b > a`.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function subtract() public pure returns (bytes32) {
        assembly {
            let small := 0x00
            mstore(0x80, sub(small, 0x02))
            return(0x80, 0x20)
        }
    }
}
```

The above function will return `0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe`.

To write a safe Yul subtraction code, this is the best approach [[6](https://github.com/ConsenSysMesh/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol)].

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function subtract(uint256 x, uint256 y) public pure returns (bytes32) {
        assembly {
            if gt(y, x) {
                revert(0x00, 0x00)
            }
            
            mstore(0x80, sub(x, y))
            return(0x80, 0x20)
        }
    }
}
```

The `gt(a, b)` Yul function takes in two numbers as arguments and returns `1` meaning `true` if `a > b` and `0`meaning `false` if `a < b`.