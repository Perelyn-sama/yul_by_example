# EtherWallet

### On Deployment
`constructor` is marked `payable`, and will accept payments >= 0 ETH to deploy contract. In this case, it retrieves the address of `msg.sender` from the `caller()` opcode and saves it in slot `0` (the `owner` variable). `receive()` allows ETH sent from external sources.

### getBalance()
To get the balance of the contract, there are two ways to go about that:
1. `balance(address())`
    `address()` returns the address of the contract in execution, `address(this)`. `balance(address _address)` returns the balance of ETH at `_address`.


2. `selfbalance()`
    This is an easier way to get the balance of the executing contract.

### withdraw()
It evaluates that `caller()` is the owner of the contract by comparing the value of `caller()` with the value stored at slot `0`. If they match, the `_amount` passed is withdrawn via `call`. If they don't, it stores the `UnauthorizedSelector` at location `0x00`, and reverts, returning the first 4 bytes of the error selector.