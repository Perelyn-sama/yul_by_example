# `bytes`

`bytes` are dynamic byte arrays. While the length of a `bytes[n]` is known as `n`, bytes do not have a specific 
length and can stretch up to `128` or even more.

For example, try running the `getByteCode()` in the `ByteCodeGenerator` contract below on Remix.
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract MyContract {
    uint16 internal a;
    uint16 internal b;
    string internal c;
    uint256 internal d;

    struct E {
        bytes32 f;
    }

    E internal e;

    constructor(uint256 _d) {
        d = _d;
    }
}

contract ByteCodeGenerator {
    function getByteCode() public pure returns (bytes memory) {
        bytes memory bytecode = type(MyContract).creationCode;
        return abi.encodePacked(bytecode, abi.encode(123));
    }
}
```

As observed, it will return a chunk of bytes in this format that has a length of `249`.

``
0x6080604052348015600e575f80fd5b5060405160d938038060d98339818101604052810190602c9190606a565b80600381905550506090565b5f80fd5b5f819050919050565b604c81603c565b81146055575f80fd5b50565b5f815190506064816045565b92915050565b5f60208284031215607c57607b6038565b5b5f6087848285016058565b91505092915050565b603e80609b5f395ff3fe60806040525f80fdfea2646970667358221220e7af087555eba8f8a284453d72cfff0475dbf8f637b5a2d261a027c32bdfa10764736f6c63430008190033000000000000000000000000000000000000000000000000000000000000007b
``

Once again, `bytes` can have an arbitrary length.

## Storage

The storage for `bytes` goes two ways.
- Storage for `bytes` with length from 31 and below.
- Storage for `bytes` with length from 32 and above.

### Storage For `bytes` With Length From 31 And Below.

This is very simple. Two factors are taken into consideration, the length of the `bytes` and the corresponding `slot`.

> 💡 `bytes` are counted in twos. This means that `0xab` is a `bytes` with a length of `1`, and `0xabcd` is a `bytes` 
> with a length of `2`.

To store this type of `bytes`, the 32-byte storage slot is broken up into two. One part to hold the 31-length 
`bytes` and the other part to hold the length of the bytes, calculated as `length * 2` [[4](https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html#bytes-and-string)].

In other words, this, <br>
`0x0000000000000000000000000000000000000000000000000000000000000000` <br> (32 bytes) <br> is broken into, <br>
`0x00000000000000000000000000000000000000000000000000000000000000 - 00` <br> (31 bytes - 1 byte).

The 31 bytes section would hold the actual `bytes` value passed, from left to right, while the 1 byte would hold the 
length as calculated above, `length * 2`.

> 💡 Storage slot bytes go from the highest order to the lowest order. Meaning that for a bytes 32 storage slot, 
> `0x0000000000000000000000000000000000000000000000000000000000000000`, `0x00` Is the highest order byte, while the last `00` is the lowest order byte.

To store a simple `bytes` value, let's say `0xabcdef` in storage, it would be stored in this way, 
`0xabcdef0000000000000000000000000000000000000000000000000000000006`. Recall what we have said and let's apply 
accordingly. The length of the `bytes` is `3` (`ab`, `cd`, `ef`), and 3 * 2 = 6. 6 when converted to hexadecimals is 
`0x06`, and we can see that in the last byte of the storage slot's value. And the actual `bytes` is then stored in 
the remaining 31 bytes, from the highest order to the lowest order.

`bytes` will always occupy one storage slot, and they cannot be packed with any other type of data type.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract MyContract {
    // Slot 0.
    bytes public myBytes = hex'01_23_45_67_89_ab_cd_ef';
    
    function getBytes() public view returns (bytes32) {
        assembly {
            mstore(0x80, sload(0x00))
            return(0x80, 0x20)
        }
    }
}
```
> Returns `0x0123456789abcdef000000000000000000000000000000000000000000000010`.

> 💡 You can separate `0x0123456789abcdef000000000000000000000000000000000000000000000010` into 
> `0x0123456789abcdef0000000000000000000000000000000000000000000000` (31 bytes) and `10` (1 byte) and study how they
> were gotten. It's the same thing as the one we did above.


### Storage For `bytes` With Length From 32 And Above.

Due to the fact that the length of the `bytes` is greater than 31, there would not be enough room in a single 
storage slot to store the length data and the actual `bytes` value. Therefore, a different approach is used.

The length data is stored at the slot, and, unlike `bytes` with lengths of 31 and below, the length data for `bytes` 
with lengths of 32 and above is calculated as `(length * 2) + 1`. This value is stored at the corresponding slot for 
the `bytes` variable. And the value for the `bytes` is then stored at `keccak256(slot)`. If we are to store a bytes 
variable with length 32 and a value at slot 0, slot 0 would hold the value of 65 ((32 * 2) + 1) while the actual 
`bytes` value will be stored at `keccak256(0)`. The keccak256 has is calculated using Yul, and not Solidity [[5](https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html#bytes-and-string)].

If the length of the `bytes` value exceed 32, they overflow in to the next storage slots. Meaning that, if we have a 
bytes with a length of 40, corresponding to slot 0, the value would be found at `keccak256(0)`, but, we would only see 
32 bytes of the entire thing, while the remaining 8 bytes would be in the next slot, `keccak256(0) + 1`

We're going to store a pretty long `bytes` value now.

```solidity
// SPDX-License-Identifier: GPL-3.0
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract MyContract {
    // Slot 0.
    bytes public myBytes = hex'01_23_45_67_89_ab_cd_ef_01_23_45_67_89_ab_cd_ef_01_23_45_67_89_ab_cd_ef_01_23_45_67_89_ab_cd_ef_01_23_45_67_89_ab_cd_ef';

    function getBytes() public view returns (bytes32) {
        assembly {
            mstore(0x80, sload(0x00))
            return(0x80, 0x20)
        }
    }
}
```
`getBytes` returns `0x0000000000000000000000000000000000000000000000000000000000000051`. Converting this to decimal 
would be 81. Subtracting 1 and dividing by 2 gives us 40, which is the actual length of the string. As explained 
earlier, this would not fit in one storage slot and would be stored in two slots, which would be found at `keccak256(0)` and `keccak256(0) + 1` respectively.

We'd write the Yul code to return them separately.
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract MyContract {
    // Slot 0.
    bytes public myBytes = hex'01_23_45_67_89_ab_cd_ef_01_23_45_67_89_ab_cd_ef_01_23_45_67_89_ab_cd_ef_01_23_45_67_89_ab_cd_ef_01_23_45_67_89_ab_cd_ef';
    
    function getBytes() public view returns (bytes32) {
        assembly {
            mstore(0x80, sload(0x00))
            return(0x80, 0x20)
        }
    }

    function getFirstBytesSection() public view returns (bytes32) {
        assembly {
            mstore(0x80, 0x00)
            let location := keccak256(0x80, 0x20)
            mstore(0x80, sload(location))
            return(0x80, 0x20)
        }
    }

    function getSecondBytesSection() public view returns (bytes32) {
        assembly {
            mstore(0x80, 0x00)
            let location := keccak256(0x80, 0x20)
            let nextLocation := add(location, 1)
            mstore(0x80, sload(nextLocation))
            return(0x80, 0x20)
        }
    }
}
```
`getFirstBytesSection` would return `0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef`, which is 
the first 32 bytes of the value we stored, while, `getSecondBytesSection` would return 
`0x0123456789abcdef000000000000000000000000000000000000000000000000`, which is the next 32 bytes, but as observed, 
it only contains values for the first 8 bytes. Using both data, we can see that our `bytes` value was spread out 
across two storage slots. We can try to concatenate them and return all the bytes, but that would involve moving 
them into memory, and then returning the proper ABI encoded memory data for the `bytes`. We would look at that when 
we get to the [Variable Storage In Memory]() section of this book.

> 💡 `bytes` and `string` share the same characteristics in storage and memory. The same way `bytes` are stored in 
storage and memory, that is the same way `string` are stored. The only differences are that each `string` character is 
> converted into their hexadecimal components before storage. And that while `bytes` characters are counted in twos, 
> `string` characters are counted singly, like you do with your everyday words.