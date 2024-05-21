# Errors

Errors are encoded using the ABI Specification. We will take a look at basic reverts, reverts of errors without 
parameters and errors with parameters.

## Basic Revert

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function basicRevert(uint256 num) public pure {
        assembly {
            if lt(num, 0x06) {
                revert(0x00, 0x00)
            }
        }
    }
}
```

## Revert Without Arguments

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    // bytes4(keccak256(NumberLess())) => 0x994823ad.

    function revertWithArgs(uint256 num) public pure {
        assembly {
            if lt(num, 0x06) {
                mstore(0x80, 0x994823ad) // 4 bytes.
                revert(0x9c, 0x04) // Reads 4 bytes.
            }
        }
    }
}
```

## Revert With Arguments

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    // bytes4(keccak256(NumberLessThan6(uint256))) => 0x8205edea
    
    function revertWithErrorMessage(uint256 num) public pure {
        assembly {
            if lt(num, 0x06) {
                mstore(0x80, 0x8205edea)
                mstore(0xa0, num)
                revert(0x9c, 0x24)
            }
        }
    }
}
```