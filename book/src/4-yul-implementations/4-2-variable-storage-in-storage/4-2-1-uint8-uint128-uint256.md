# `uint8`, `uint128`, `uint256`

Unsigned integers are stored in memory based on the size of bytes they have. The size of `uint[n]` bytes can be realized by dividing `[n]` by 8, meaning that, while small `uint[n]` values like `uint8` have 1 byte, `uint256` has 32 bytes. Solidity's storage is designed in such a way that it can contain up to 32 bytes of value in one slot. In a situation where a variable doesn't contain up to 32 bytes, the value is stored and the next variable will be **packed** into the same slot, on the condition that when the bytes are added to the slot, it doesn't exceed 32 bytes.


`uint256` => 32 bytes => Slot 0.

This is the maximum, hence it occupies an entire slot of its own. Whatever bytes we are going to add will exceed 32 and hence, will pick up the next slot, slot 1.

`uint128` => 16 bytes => Slot 1. We still have 16 bytes left to be filled. <br>
`uint128` => 16 bytes => Slot 1. Slot 1 is full.

`uint8` => 1 byte => Slot 2. There is still 31 bytes left. And as long as the subsequent variable bytes when added to the existing bytes in slot 2 is less than 32, they will all be packed in Slot 2.

### Single uint8 Value
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    // Slot 0.
    uint8 internal smallUint;
    
    function storeUint8() public {
        assembly { 
            // Store the number 16 in slot 0.
            sstore(0x00, 0x10)
        }
    }
    
    function getUint8() public view returns (bytes32) {
        assembly {
            let val := sload(0x00)
            mstore(0x80, val)
            return(0x80, 0x20)
        }
    }
}
```

Here, we called the `sstore` command, which takes in two arguments, the slot and the value to store in the slot.

> `sstore(slot, value)`

Slots start from index 0 and increment with every variable added, unless those variables are packed. To know which slot what data is written to, you have to sum up the bytes of all variables, divide by 32 and take the quotient.

> 8/32 = 0 r 8, hence, slot 0.

To retrieve a value stored at a storage location, the `sload` keyword is used, and it takes in an argument, the slot to load the data from.

> `sload(slot)`

In a function, to return a value loaded from the storage, without declaring a return variable name, we have to move the value to be returned from storage to memory using `mstore` which like `sstore` takes two arguments, what position in memory to store the data at and what data to store. Recall we stated that `0x80` is the start of the free memory that we can play around with. So, our command to the EVM is, store the value loaded `val` at memory location `0x80`. Then, `return`, 32 bytes of data starting from memory location `0x80`.

`return` is a Yul keyword that takes in two arguments like the others, the position in memory to return from and the size of bytes to return.

> `return(position, size)`

If we called the `getUint8` function to return a `uint8`, Solidity will handle the conversion for us and we will see `16` returned. However, we will be returning in bytes32 over the course of this book to understand the actual storage and memory layouts of the EVM.

Calling the `getUint8` function will return `0x0000000000000000000000000000000000000000000000000000000000000010`, which when converted to decimal, equals to `16`, the value we stored.

To get a glimpse of Solidity doing the automatic conversion of `bytes32` to `uint8`, we can rewrite the code to this:
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    // Slot 0.
    uint8 internal smallUint;
    
    function storeUint8() public {
        assembly { 
            // Store the number 16 in slot 0.
            sstore(0x00, 0x10)
        }
    }
    
    function getUint8() public view returns (uint8 _val) {
        assembly {
            _val := sload(0x00)
        }
    }
}
```

Variables declared within a function are in the scope of Yul, also, named return variables are within the scope of Yul.

> 🚨 Only use this method if you are sure that the data returned occupies the entire 32 byte slot. Returning a packed slot would result in wrong returns.

### Packed uint8 Value.
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    uint8 internal uint1 = 1; // Slot 0
    uint8 internal uint2 = 2; // Slot 0
    uint8 internal uint3 = 3; // Slot 0
    uint8 internal uint4 = 4; // Slot 0
    uint8 internal uint5 = 5; // Slot 0
    
    function getUint8() public view returns (bytes32) {
        assembly {
            let val := sload(0x00)
            mstore(0x80, val)
            return(0x80, 0x20)
        }
    }
}
```

Calling the `getUint8` function returns `0x0000000000000000000000000000000000000000000000000000000504030201`, which when observed closely, is a pack of the 5 uint8 variables we have declared in hex format, `01`, `02`, `03`, `04` and `05`. And it is nice to observe that they were packed in order of first to last, from right to left.

Retrieving values from this one is not as straight forward as it was, this is where we consider `offsets`, `shifts` and `masks` in Yul.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    uint8 internal uint1 = 1; // Slot 0, offset 0.
    uint8 internal uint2 = 2; // Slot 0, offset 1.
    uint8 internal uint3 = 3; // Slot 0, offset 2.
    uint8 internal uint4 = 4; // Slot 0, offset 3.
    uint8 internal uint5 = 5; // Slot 0, offset 4.
    
    // Return the value of the 5th uint8 variable.
    function getUint8() public view returns (bytes32) {
        assembly {
            let val := sload(0x00)
            let bytesToShiftLeft := sub(0x20, add(uint5.offset, 0x01))
            let leftShift := shl(mul(bytesToShiftLeft, 0x08), val)
            let rightShift := shr(mul(0x1f, 0x08), leftShift)
            mstore(0x80, rightShift)
            return(0x80, 0x20)
        }
    }
}
```
You can get the offset of a variable in storage by passing `<variableName>.offset`. And likewise, you can get the slot of any variable in storage by passing `<variableName>.slot`. Easier than calculating, isn't it?

If you can understand the layout of the data you're returning, you can then manipulate it to return what you desire. We will see how this works when we take a look at arrays. If you can't understand it at the moment, do not fret. Practise, play around with `offset` and `shift`.

> 🚨 Understand the layout of your values before using Yul to manipulate them.

### Single uint128 Value
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    // Slot 0.
    uint128 internal mediumUint;
    
    function storeUint128() public {
        assembly { 
            sstore(0x00, 0x1234567890)
        }
    }
    
    function getUint128() public view returns (bytes32) {
        assembly {
            let val := sload(0x00)
            mstore(0x80, val)
            return(0x80, 0x20)
        }
    }
}
```
> Returns `0x0000000000000000000000000000000000000000000000000000001234567890`.

### Packed uint128 Value
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    // Slot 0.
    uint128 internal mediumUint = 9840913809138;
    uint128 internal mediumUint2 = 9304137410311;
    
    function getUint128() public view returns (bytes32) {
        assembly {
            let val := sload(0x00)
            mstore(0x80, val)
            return(0x80, 0x20)
        }
    }
}
```
> Returns `0x00000000000000000000087649ce27070000000000000000000008f3442bfef2`.

### Single uint256 Value
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    // Slot 0.
    uint256 internal bigUint;
    
    function storeUint256() public {
        assembly { 
            sstore(0x00, 0x1234567890abcdef)
        }
    }
    
    function getUint256() public view returns (bytes32) {
        assembly {
            let val := sload(0x00)
            mstore(0x80, val)
            return(0x80, 0x20)
        }
    }
}
```
> Returns `0x0000000000000000000000000000000000000000000000001234567890abcdef`.