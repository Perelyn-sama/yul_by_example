# Variable Storage In Memory

Variables declared inside a function's body, or returned by a function are stored in memory, except in special cases with libraries, internal and private functions that can return variables stored in storage. The memory, unlike the storage is not divided up into slots, but rather is a vast area of data grouped into 32 bytes. The retrieval of data from memory is even more tricky than that of storage, because, unlike storage that restricts us to read from and write to one slot at a time, we can read from anywhere in memory and write to anywhere in memory arbitrarily. We can start our data reading from location `0x00`, or `0x78`, or `0x0120`, or `0x3454`. The memory is very similar to the `calldata` in terms of data storage. They both have the same layout, the only difference being that the `calldata` is prepended with `4 bytes` of data that we know as the `function signature`.

When a value is stored in memory, Solidity automatically stores the highest variant of its type in memory. Meaning that storing a data of type `uint8` will store a `uint256` type of the same number in memory, occupying an entire 32-byte memory space.

Data in the memory and `calldata` are stored according to the standard ABI specification [[3](https://docs.soliditylang.org/en/latest/internals/layout_in_memory.html#)], **and they are not packed**.

In this section, we will take a look at the different ways data types are stored in memory.

Head into the start of the section at [`uint8`, `uint128`, `uint256`](4-3-1-uint8-uint128-uint256.md).