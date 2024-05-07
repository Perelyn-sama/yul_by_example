# Solidity's Storage And Memory Layout

We have understood what the storage and memory are. Persistent and temporary, respectively. Now we are going to take a look at how these two data storage locations are laid out.

### Storage
Solidity's storage layout has a finite amount of space, which is broken down into 32-byte groups called `slots`, and each slot can hold a 256-bit value. These slots start from index 0 and can stretch to a theoretical index limit of somewhere around `(2^256) - 1`. It is safe to say that the storage can never get full. Cool, isn't it?

Values stored in storage slots are stored as `bytes32` values, and sometimes, can be packed, as we will see later on in this book. To retrieve the value of a Solidity storage variable, the 32-byte value stored in the corresponding slot is retrieved. In some cases - when the value in the slot has been packed -, the value retrieved is worked on by methods of shifting or masking to retrieve the desired value.

> 💡 Remember when we said one should know how the EVM works before moving on with Yul? Yeah, that's one of the reasons why. You cannot retrieve what you do not know how it was stored.

### Memory
Solidity's memory layout, unlike the storage layout is quite tricky. While the storage has a defined maximum slot 
index of 
`(2 **256) - 1` that can hold 32-byte values, the memory is a large group of 32-byte slots that their data can not 
be retrieved by passing a slot index. But instead, data stored in the memory are retrieved by picking
a particular location and returning a specific number of bytes from that point in the memory.

"Why?", you may ask, it is because the default number of bytes returned from any point in memory is `32` and in 
cases where the point started from is the middle of a particular 32-byte slot, it will encroach into the next slot.

You can imagine memory slots as laid out end to end, in a way that data retrieval can be started from any point and 
stopped at any point. Unlike storage that returns only the 32-bytes stored at an index, nothing more, nothing less.

If you do not understand that, do not
sweat it. You will get a better grasp of it when we talk about [variable storage in memory]().

These positions in memory start from `0x00` and are in groups of 32-bytes, meaning that the slots are in th is way:

`0x00` - `0x1f` <br>
`0x20` - `0x3f` <br>
`0x40` - `0x5f` <br>
`0x60` - `0x7f` <br>
... <br>
`0xm0` - `0xnf`

According to the [Solidity Docs](https://docs.soliditylang.org/en/latest/internals/layout_in_memory.html), there are 
some reserved memory slots for some purposes.

`0x00` - `0x3f` (64 bytes): Scratch space for hashing methods. <br>
`0x40` - `0x5f` (32 bytes): Currently allocated memory size (aka. free memory pointer). <br>
`0x60` - `0x7f` (32 bytes): Zero slot.

Scratch space can be used between statements (i.e. within inline assembly). The zero slot is used as initial value 
for dynamic memory arrays and should never be written to (the free memory pointer points to 0x80 initially) [[3](https://docs.soliditylang.org/en/latest/internals/layout_in_memory.html)].

> 💡 Position `0x40` always holds the next free memory location.

> 💡 It is safest to use `mload(0x40)` to get the next free memory pointer when trying to store data to memory as 
> storing in a memory location with existing data overwrites that location.

> 💡 The positions we will use over the course of this book to access memory points will be written in hexadecimals 
> (`0x**`) 
as it's easier to read, since the EVM already deals in hexadecimals.