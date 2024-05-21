# Send Ether

Sends a specified `msg.value` to an address using `call()`.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    receive () external payable {}
    
    function sendEther(uint256 amount, address to) external {
        assembly {
            let s := call(gas(), to, amount, 0x00, 0x00, 0x00, 0x00)
            
            if iszero(s) {
                revert(0x00, 0x00)
            }
        }
    }
}
```

`call(a, b, c, d, e, f, g)` takes in 7 arguments:

`a` - The gas. Gotten by calling the `gas()` function in Yul. <br>
`b` - Recipient, an address. <br>
`c` - `msg.value`, amount to send. <br>
`d` - `offset`, for `calldata`. <br>
`e` - size, for `calldata`. <br>
`f` - Return data offset. <br>
`g` - Return data size.

It returns true or false depending on the success of the transaction.

`delegatecall(a, b, d, e, f, g)` and `staticcall(a, b, d, e, f, g)` take exactly the same as `call(a, b, c, d, e, f, g)` except the `msg.value` (`c`) argument.

They all return the same thing, `true` or `false`.

Check them out at evm.codes at [`call`](https://www.evm.codes/#f1?fork=cancun), [`delegatecall`](https://www.evm.codes/#f4?fork=cancun) and [`staticcall`](https://www.evm.codes/#fa?fork=cancun).