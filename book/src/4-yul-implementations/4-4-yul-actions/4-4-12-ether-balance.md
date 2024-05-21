# Ether Balance

---

This is how you check the Ether balance of an address on any EVM chain.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function getBalance(address _address) public view returns (bytes32) {
        assembly {
            mstore(0x80, balance(_address))
            
            return(0x80, 0x20)
        }
    }
}
```

The `balance(a)` function will take in an address and return the Ether balance of that address.