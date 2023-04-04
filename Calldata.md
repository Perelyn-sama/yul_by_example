## Calldata Encoding
`NOTE:` `m` => memory location, `c` => calldata location (which is still memory, but dedicated at the moment).

This file is used to elaborate how the arguments encoded in the src/Calldata.sol file have been encoded for all functions defined in the CallerContract contract.


### Function 1:
#### `callAdd`
##### Assume num = 7
This calls the `add(uint256)` function with selector => `0x1003e2d2`. The calldata arguments for the `add` function can fit into the `scratch space` i.e. first 64 bytes of memory, `0x00` to `0x5f`. So we can comfortably fill it between `0x00` and `0x5f`.

###### Encoding
c : ----------- | m : 0x00 - 0x1f | 4 bytes, starting from 1f
=> 0x000000000000000000000000000000000000000000000000000000001003e2d2
=> Function Selector (This part of the memory is not included as a starting point in the calldata, but a place to store the selector of the function to call).

c : 0x00 - 0x1f | m : 0x20 - 0x3f | 32 bytes
=> 0x0000000000000000000000000000000000000000000000000000000000000007
=> Hex encoding of the number we want to pass as argument to the function selector.

Total: 36 bytes | 36 | 0x24

### Function 2:
#### `callMultiply`
##### Assume num1 = 6, num2 = 7
This calls the `multiply(uint8,uint8)` function with selector => `0x6a7a8e0b`. The data arguments we need will not be contained in the `scratch space` as they're `the selector`, `num1` and `num2`, all 32 bytes. We will need to encode them in the free memory, which starts from `0x80`. Also, despite us having `uint8` types which would mean `0xff`, the `ABI` demands we pass them as 32 bytes as well.

###### Encoding
c : ----------- | m : 0x80 - 0x9f | 4 bytes, starting from 9f
=> 0x000000000000000000000000000000000000000000000000000000006a7a8e0b

c : 0x00 - 0x1f | m : 0xa0 - 0xbf | 32 bytes
=> 0x0000000000000000000000000000000000000000000000000000000000000006
=> Hex encoding of the first argument to the function selector.

c : 0x20 - 0x3f | m : 0xc0 - 0xdf | 32 bytes
=> 0x0000000000000000000000000000000000000000000000000000000000000007
=> Hex encoding of the second argument to the function selector.

Total: 68 bytes | 68 | 0x44