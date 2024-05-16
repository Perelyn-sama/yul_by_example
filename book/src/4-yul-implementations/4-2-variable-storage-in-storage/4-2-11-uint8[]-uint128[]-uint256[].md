# `uint8[]`, `uint128[]`, `uint256[]`

Up till now, we've learnt about individual data types in Solidity and how they are stored in storage. Before we proceed to their array counterparts, we would want to go over how arrays are viewed in Solidity storage generally. This view is applied to all other types.

Solidity recognizes two types of arrays, the fixed length array and the dynamic array. These two array types are 
treated differently by Solidity.

## Fixed Arrays, `<type>[n]`

Solidity views `<type>[n]` array elements as individual values. Which means that, these values are treated as if they 
were
not in an array. If a `uint256[5]` array has 5 elements, they will occupy 5 slots, in their correct places.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    // Slots 0 - 4.
    uint256[5] public fixedArray;
    // Slot 5.
    uint8[6] public fixedSmallArray;
}
```
In the code above, the `fixedArray` variable occupies 5 slots. This is because, it contains 5 `uint256` values. In 
Solidity, because the length of the array is fixed (in this case, 5), Solidity knows how much in storage to allocate 
for the storage of each individual value. It is seen as if they're 5 `uint256` values kept side by side.

The `fixedSmallArray` occupies one slot, because, as explained, it will be seen as 6 `uint8` values kept side by 
side and they, like we have already discussed, will be packed into one slot.

## Dynamic Arrays, `<type>[]`

Dynamic arrays are stored just like fixed arrays, when it comes to packing, but in terms of knowing **where** in 
storage to store the array, a little bit of calculation is done. Because the length is dynamic, Solidity does not 
know how much space to allocate for the storage, therefore, the storage of a dynamic array starts at `keccak256(slot)
`. Meaning that, if a dynamic array is declared at slot 0, the first element will be found `keccak256(0)`.

To read the value of the other array elements from storage, they will be obtained by loading the storage at 
`keccak256(slot) + elementIndex`. Meaning that, if we had the above dynamic array that grew to 10 elements, and we 
would 
like to retrieve the value of the 9th element, it would be found at `keccak256(0) + 9`.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    // Slot 0.
    uint256[] public dynamicArray;
    // Slot 1.
    uint8[] public dynamicSmallArray;
}
```

The values of the elements in the dynamicArray variable can be found at `keccak256(0) + elementIndex`. While the 
values for the `dynamicSmallArray` will be found at `keccak256(1)`, we didn't add any `elementIndex` here because 
the elements of `dynamicSmallArray` will be packed in one slot because they're `uint8` and will be packed. If they are 
more than enough to fit into the next slot, then, we can load the next storage location.

## General `<type>[]` Deduction.

Once the concept of type storages is understood, you can use that to figure out how the array versions of that type 
will be stored.

You can use the knowledge of arrays to write to any array index, or read from an array index.

To retrieve an element from a packed array is quite trick and is not readily advised.

> 🚨 The use of Yul to read and write arrays is not advised. It is a very tricky business.