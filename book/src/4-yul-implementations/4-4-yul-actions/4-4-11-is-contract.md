# Is Contract

---

This is used to check if an address is the address of a smart contract or an EOA.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function isContract(address _address) public view returns (bool) {
        assembly {
            let size := extcodesize(_address)
            
            switch size
            case 0 { mstore(0x80, 0x00) }
            default { mstore(0x80, 0x01) }
            
            return(0x80, 0x20)
        }
    }
}
```

The `extcodesize(a)` function takes in an address and returns the size of the contract code at that address, for EOAs, it's 0, for contracts, it's greater than 0.

In this case, we returned `bool` and Solidity automatically converted it for us. Had we returned `bytes32` like we did below, we would have seen `0x01` for `true` and `0x00` for `false`.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function isContract(address _address) public view returns (bytes32) {
        assembly {
            let size := extcodesize(_address)
            
            switch size
            case 0 { mstore(0x80, 0x00) }
            default { mstore(0x80, 0x01) }
            
            return(0x80, 0x20)
        }
    }
}
```