# Array
```solidity
contract Array {
    uint8[3] public fixedU8Array;
    uint8[] public dynamicU8Array;
    
    uint256[3] public fixedU256Array;
    uint256[] public dynamicU256Array;
}

/*
*   Array Variable    |   Slot(s) Occupied    |   Values Stored At Slot(s) [sload(slot)]
*   __________________|_______________________|___________________________________________________
*   fixedU8Array      |   0 - 2               |   0 <= x <= 2 
*   dynamicU8Array    |   3                   |   keccak256(3) + (0 <= x < dynamicU8Array.length)
*   fixedU256Array    |   4 - 6               |   4 <= x <= 6
*   dynamicU256Array  |   7                   |   keccak256(7) + (0 <= x < dynamicU256Array.length)
*   _______________________________________________________________________________________________
*/
```

## Array Storage
Arrays in Yul take up slots depending on their array type. Array types include:
- Fixed Array, i.e. `fixedU256Array`
- Dynamic Array, i.e. `dynamicU256Array`

Because the length of a fixed arrays are known, they take up slots as much as their length. i.e. `fixedU256Array` is of length `3`, therefore, it will take up 3 slots starting from its current slot. However, slot taking of a fixed array is also controlled by its data type, uint256 will take up an entire slot. So there will be as many slots occupied as 3 `uint256` numbers in the `fixedU256Array`.

In the case of `fixedU8Array`, which has a known length of 3, because it's of type `uint8`, it will be packed in that slot where it should start from.

Dynamic arrays are different, because, their lengths are not known, so there is no set amount of slots allocated for it, therefore, at their slots, which we will call `slot`, the length of the array is stored. Then the array elements can be found starting at slot `keccak256(slot)` and spanning up till `keccak256(slot)` + ((the length of the array) - 1).

If dynamicU256Array should have 5 elements, at its slot in storage, which we will assume as `c`, the value `5` will be stored. Then to get these 5 elements, they will be found at:<br><br>
Index 0 => `keccak256(c) + 0`<br>
Index 1 => `keccak256(c) + 1`<br>
Index 2 => `keccak256(c) + 2`<br>
Index 3 => `keccak256(c) + 3`<br>
Index 4 => `keccak256(c) + 4`<br><br>
All 5 elements. Adding one element to the array will increment the value at slot `c` to `6` and also add an:<br><br>
Index 5 => `keccak256(c) + 5`<br><br>
Which is the `6th` element.

## Reading From An Array

While reading the elements of the `fixedU256Array` is simple, because, type `uint256` takes up 32 bytes, the same cannot be said for the `fixexU8Array` as they're packed and care would be taken to avoid messing up the value stored at that slot. We can always call an `sload(slot)` to get the value of any index stored at any slot.

However, for `fixedU8Array` on initialization:
```solidity
contract Array {
    uint8[3] public fixedU8Array;

    constructor() {
        // Initialize array variables.
        fixedU8Array = [1, 2, 3];
    }
}
```

Once the slot where the values of the `fixedU8Array` has been located, which we shall address as `loc`, we can call a simple `sload(loc)` to get the value stored at that slot, which will be returned as:
```solidity
0x0000000000000000000000000000000000000000000000000000000000030201
```
It will be packed, as stated earlier. We can then use a masking to return any index in the array based of the `uint8` type, `1 byte` by calculating its offset precisely.

### More Info
[Click to read more.](https://rb.gy/yvbfwf)