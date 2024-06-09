# `address`

---

`address` is a `bytes20` or `uint160` value, it holds 20 bytes of data. Since `address` take up 20 bytes of a 
storage slot, they can be packed with any number of types that can sum up to 12 bytes.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    address public a;
        
    function setAndReturnAddress() public returns (bytes32) {
        assembly {
            // My Remix address is `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`.
            sstore(0x00, caller())
            mstore(0x80, sload(0x00))
            return(0x80, 0x20)
        }
    }
}
```

> Returns `0x0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4`. As seen, the last 20 bytes of the bytes32 corresponds to the address I made the contract call with. `caller()` in Yul equates to `msg.sender` in Solidity.

To understand how `address`, `bytes20` and `uint160` types co-relate, read up [this section](https://docs.soliditylang.org/en/latest/types.html#address) from the Solidity documentation.