# Custom Types

---

A custom type or a user-defined value type allows you to create an alias of a native type in Solidity. This alias, will inherit and act as if it is the original type. It is defined by using the `type C is V syntax`, where `C` is the custom type, and `V` is the native type. To convert from the underlying type to the custom type, `C.wrap(<value>)` is used, and to convert from the custom type to the native underlying type, `C.unwrap(<value>)` is used [[5](https://docs.soliditylang.org/en/latest/types.html#user-defined-value-types)].

Custom types behave like their underlying types.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    type CustomTypeUint8 is uint8;      // Will behave like uint8.
    type CustomTypeUint256 is uint256;  // Will behave like uint256.
    type CustomTypeInt128 is int128;    // Will behave like int128.
    type CustomTypeAddress is address;  // Will behave like address.
    type CustomTypeBytes4 is bytes4;    // Will behave like bytes4.
    type CustomTypeBytes32 is bytes32;  // Will behave like bytes32.
    
    // Slot 0.
    CustomTypeUint256 public customType = CustomTypeUint256.wrap(12000);
    // Slot 1.
    uint256 public underlyingType = CustomTypeUint256.unwrap(customType);
    
    function getCustomType() public view returns (bytes32) {
        assembly {
            mstore(0x80, sload(0x00))
            return(0x80, 0x20)
        }
    }

    function getUnderlyingType() public view returns (bytes32) {
        assembly {
            mstore(0x80, sload(0x01))
            return(0x80, 0x20)
        }
    }
}
```

> 🚨 You cannot define custom types for `bytes` and `string`.