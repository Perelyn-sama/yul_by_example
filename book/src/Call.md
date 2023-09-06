# Call
Calldata encoding: https://rb.gy/vmzhck. <br>

The callContract function in the CallerContract contract calls the setNumber function in the CalledContract contract via a call opcode. This opcode takes in 7 arguments:
`gas`<br>
`address`<br>
`value`<br>
`dataOffset`<br>
`dataSize`<br>
`returnDataOffset`<br>
`returnDataSize`<br>

### `gas`
Amount of gas to send in `call`, usually set to `gas()` or any specified number, `n`.

### `address`
Address to make `call` to. If the address does not have a function that matches the identifier, the `fallback` function is called. If it doesn't have one, it returns `false`.

`NOTE`: `Call`s made to invalid addresses return true, `call` returns false on two occassions:
1. The address has no `fallback` function.
2. The function called reverts.

### `value`
Amount in ETH to be sent.

### `dataOffset` and `dataSize`
The `dataOffset` and `dataSize` are determined by the size of the encoded calldata sent to the `adderss`.

First, we store the function selector, `3fb5c1cb`, which we already have as a literal in location `0x00`, setting location `0x00` to `0x1f` to:
```assembly
0x000000000000000000000000000000000000000000000000000000003fb5c1cb
```
NOTE: If we store the selector in a variable:
```solidity
bytes4 selector = 0x3fb5c1cb;
```
and then save it to location 0x00, we will have:
```assembly
0x3fb5c1cb00000000000000000000000000000000000000000000000000000000
```
`PS:` FIXED AND DYNAMIC BYTE ARRAYS ARE LEFT ALIGNED, EVERYTHING ELSE IS RIGHT ALIGNED.<br>

We can then encode the number we want to pass, takes as `4`, in the next location `0x20` - `0x3f`, leaving us with:
```assembly
0x0000000000000000000000000000000000000000000000000000000000000004
```
In location `0x20` - `0x3f`. We can then calculate the offset and size of bytes we want to pass through in our `call` opcode by observing the location of `3f` in location `0x00` - `0x1f`, getting the size in bytes from that point to `0x1f`, and then adding it to `32` bytes, which is the size of the data stored in location `0x20` - `0x3f`.

The location of `3f` is `0x1c`, our `dataOffset`.

This will leave us with `0x1c` to `0x1f`, which is 4 bytes, and `0x20` - `0x3f` which is 32 bytes. 32 bytes + 4 bytes = `36 bytes`, our data size.

```assembly
let success := call(gas(), _called, 0, 0x1c, 0x24, 0, 0)
// 0x1c == Offset.
// 0x24 == 36 bytes.
```

### `returnDataOffset` and `returnDataSize`
Specifies the offset and size of the data returned from the call to copy to memory. The returnDataSize is obtained via the `returndatasize()` opcode in Yul. The offset is any offset specified by the developer to match his desired returned value. If there is no returned data or the returned data is not needed, `0x00` or `0` can be passed for both cases.
```assembly
let success := call(gas(), _called, 0, 0x1c, 0x24, 0, 0)
```