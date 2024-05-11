# `bytes1`, `bytes16`, `bytes32`

`bytes[n]` are fixed length byte arrays, as opposed to `bytes` that are variable length byte arrays. The storage of `bytes[n]` in storage is such that it takes up a slot when it is of `bytes32` and is packed in cases of bytes below `32`. It is very similar to the `uint` type.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    bytes1 public a = 0xaa;
    bytes1 public b = 0xbb;
    bytes1 public c = 0xcc;
    
    function getBytes1() public view returns (bytes32) {
        assembly {
            let val := sload(0x00)
            mstore(0x80, val)
            return(0x80, 0x20)
        }
    }
}
```
> Returns `0x0000000000000000000000000000000000000000000000000000000000ccbbaa`, just like in `uint`'s case.

However, there is some bit of caution to be proceeded with when dealing with `bytes[n]`. Take a look at these three pieces of code written using `bytes4`.
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    bytes4 public a = 0xaabbccdd;
    
    function getBytes4() public view returns (bytes32) {
        assembly {
            let val := sload(0x00)
            mstore(0x80, val)
            return(0x80, 0x20)
        }
    }
}
```
A call to the `getBytes4` function would return `0x00000000000000000000000000000000000000000000000000000000aabbccdd`, which is what we expect, according to what we have learnt.

Take a look at the second one.
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    bytes4 public a;
        
    function setAndReturnBytes4() public returns (bytes32) {
        bytes4 f = 0xaabbccdd;

        assembly {
            sstore(0x00, f)
            mstore(0x80, sload(0x00))
            return(0x80, 0x20)
        }
    }
}
```

This will return `0xaabbccdd00000000000000000000000000000000000000000000000000000000`. You can find this by checking the Remix Console, expanding the transaction and checking the `decoded output` object. This is wrong, and will set the value of `a` to `0x00000000`.

And a look at the final one.
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    bytes4 public a;
        
    function setAndReturnBytes4() public returns (bytes32) {
        assembly {
            sstore(0x00, 0xaabbccdd)
            mstore(0x80, sload(0x00))
            return(0x80, 0x20)
        }
    }
}
```

This will return `0x00000000000000000000000000000000000000000000000000000000aabbccdd`.

Setting a `bytes[n]` variable in a function will right-pad it to 32 bytes. Whereas, directly assigning the variable in a Yul block or in storage will handle it normally by left padding it.


### bytes16
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    bytes16 public a;
        
    function setAndReturnBytes16() public returns (bytes32) {
        assembly {
            sstore(0x00, 0x0011223344556677889900aabbccddeeff)
            mstore(0x80, sload(0x00))
            return(0x80, 0x20)
        }
    }
}
```
> Returns `0x0000000000000000000000000000000011223344556677889900aabbccddeeff`.

### bytes32
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    bytes32 public a;
        
    function setAndReturnBytes32() public returns (bytes32) {
        assembly {
            sstore(0x00, 0x003344556677889900aabbccddeeff0011223344556677889900aabbccddeeff)
            mstore(0x80, sload(0x00))
            return(0x80, 0x20)
        }
    }
}
```
> Returns `0x003344556677889900aabbccddeeff0011223344556677889900aabbccddeeff`.