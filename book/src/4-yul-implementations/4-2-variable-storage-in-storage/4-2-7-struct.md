# `struct`

---

A `struct` is a group of data. The layout of a `struct` is identical to the layout of the data within a `struct`. The slots a `struct` would occupy is dependent on the types of variables within the struct. A struct with two `uint256` types would occupy two slots.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract SimpleStruct {
    struct S {
        uint256 a;          // Slot 0.
        uint256 b;          // Slot 1.
        uint256 c;          // Slot 2.
        address owner;      // Slot 3.
        bytes12 structHash; // Slot 3.
    }

    S public s;
}
```

The storage and retrieval of data from a struct aligns with the storage and retrievals of what we have discussed so far.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    struct S {
        uint256 a;          // Slot 0.
        uint256 b;          // Slot 1.
        uint256 c;          // Slot 2.
        address owner;      // Slot 3.
        bytes12 structHash; // Slot 3.
    }

    S public s;
    
    constructor() {
        s = S(
            10, 15, 20,
            msg.sender,
            bytes12(keccak256(abi.encode("Hello World!")))
        );
    }
    
    function getStructSlotValue(uint8 slot) public view returns (bytes32) {
        assembly {
            mstore(0x80, sload(slot))
            return(0x80, 0x20)
        }
    }
}
```
We are trying to retrieve the data in the struct, and since the struct occupies 4 slots, we want to make the data retrieval flexible, allowing the user to pass which slot they want to retrieve its value, using the `slot` parameter.

> 😉 Try to retrieve slot number 3 and figure out how it was packed. Then, try to study slots 0, 1 and 2.

If a struct contains a `bytes` or a `string` type, it is stored the same way it is supposed to be.