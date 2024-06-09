# Addition

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function add(uint256 x, uint256 y) public pure returns (bytes32) {
        assembly {
            mstore(0x80, add(x, y))
            return(0x80, 0x20)
        }
    }
}
```

The `add(a, b)` Yul command takes in two numbers as arguments and returns their sum, `a + b`.

> 🚨 Additions in Yul are `unchecked`, meaning that, Yul wraps around numbers if they exceed the highest possible number to be stored in a slot.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function add() public pure returns (bytes32) {
        assembly {
            let large := 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
            mstore(0x80, add(large, 0x03))
            return(0x80, 0x20)
        }
    }
}

```

The above will return `0x0000000000000000000000000000000000000000000000000000000000000002` showing a wrap around.

To write a Yul addition code to check for overflows and prevent them, this will be the approach to use [[6](https://github.com/ConsenSysMesh/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol)].

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function add(uint256 x, uint256 y) public pure returns (bytes32) {
        assembly {
            if lt(add(x, y), x) {
                revert(0x00, 0x00)
            }

            mstore(0x80, add(x, y))
            return(0x80, 0x20)
        }
    }
}
```