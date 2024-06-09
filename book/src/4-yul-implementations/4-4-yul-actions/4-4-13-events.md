# Events

---

Events are classified as logs on the blockchain. It ranges from [`log0`](https://www.evm.codes/#a0?fork=cancun) to [`log4`](https://www.evm.codes/#a4?fork=cancun).

## `log[n]`

`n` shows the number of topics in an event. For `anonymous` events they can have up to `4` `indexed` event arguments. For the other types of events, the first `topic` is the event hash, a 32 byte value of the hashed event signature. The subsequent topics are `indexed` event arguments.

If your `anonymous` event has `x` `indexed` arguments where `0 <= x <= 4`, the corresponding `log[n]` to be used would be `log[x]`.

If your non-anonymous event has `x` `indexed` arguments where `0 <= x <= 3`, the corresponding `log[n]` to be used would be `log[x + 1]`.

The `log[n]` for a non-anonymous event takes in a range of 2 to 6 arguments, as defined by `n + 2`, the first two being the part of the `calldata` where non-`indexed` values are stored according to the ABI Specification. Then the number of `indexed` events as much as `n`.

If we have a non-`anonymous` event with 2 `indexed` arguments, we will use `log3`, and `log3` would take in `5` arguments.

These five arguments would be `log2(a, b, c, d, e)`, `a`, the `offset`, the part of memory where the stored non-`indexed` values start, `b`, the `size` of the memory to be read, `c`, the event `topic`, `d`, the value of the first `indexed` argument, `e`, the value of the second `indexed` argument.

If we have an `anonymous` event with 2 `indexed` arguments, we will use `log2`, and `log2` would take in `4` arguments.

These four arguments would be `log2(a, b, c, d)`, `a`, the `offset`, the part of memory where the stored non-`indexed` values start, `b`, the `size` of the memory to be read, `c`, the value of the first `indexed` argument, `d`, the value of the second `indexed` argument.

`anonymous` events without `indexed` arguments are emitted using `log0`.

## `indexed` Event

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    // Event to emit.
    event IndexedEvent(address indexed a, uint256 indexed b);

    bytes32 public constant IndexedEventTopic = 0xfdcfbb6e25802e9ba4d7c62d4a85a10e40219c69383d35be084b401980dd7156;

    function emitIndexedEvent(uint256 x) public {
        assembly {
            log3(0x00, 0x00, IndexedEventTopic, caller(), x)
        }
    }
}
```

## Non-`indexed` Event

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    // Event to emit.
    event NonIndexedEvent(uint256 a, uint256 b);

    bytes32 public constant NonIndexedEventTopic = 0x8a2dba84c9d33350ff3006c2607aae76d062ae5ac6632d800030613bcf7f74a0;
    
    function emitNonIndexedEvent(uint256 a, uint256 b) public {
        assembly {
            mstore(0x80, a)
            mstore(0xa0, b)
            log1(0x80, 0x40, NonIndexedEventTopic)
        }
    }
}
```

## `anonymous` `indexed` Events

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    // Event to emit.
    event AnonymousIndexedEvent(address indexed a, uint256 indexed b) anonymous;

    function emitAnonymousIndexedEvent(uint256 x) public {
        assembly {
            log3(0x00, 0x00, caller(), x)
        }
    }
}
```

## `anonymous` non-`indexed` Events

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    // Event to emit.
    event AnonymousNonIndexedEvent(address a, uint256 b) anonymous;
    
    function emitAnonymousNonIndexedEvent(uint256 a, uint256 b) public {
        assembly {
            mstore(0x80, a)
            mstore(0xa0, b)
            log1(0x80, 0x40)
        }
    }
}
```