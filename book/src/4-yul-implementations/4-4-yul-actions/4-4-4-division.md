# Division

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function divide(uint256 x, uint256 y) public pure returns (bytes32) {
        assembly {
            mstore(0x80, div(x, y))
            return(0x80, 0x20)
        }
    }
}
```

The `div(a, b)` Yul command takes in two numbers as arguments and returns their quotient, `a / b`.

To write a Yul divion code to check for zero divisions and prevent them, this will be the approach to use [[6](https://github.com/ConsenSysMesh/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol)].

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function divide(uint256 x, uint256 y) public pure returns (bytes32) {
        assembly {
            if eq(y, 0) {
                revert(0x00, 0x00)
            }
            
            if eq(x, 0) {
                return(0x80, 0x20)
            }

            let z := div(x, y)

            mstore(0x80, z)
            return(0x80, 0x20)
        }
    }
}
```