# Using Yul To Read And Write Directly To Storage And Memory

---

Remember when we said keep [evm.codes](https://evm.codes) handy? You can go to the website and take a look at some Yul commands. Take note of the `mload`, `mstore`, `mstore8`, `sload` and `sstore`.

`mload` is short for Memory Load. <br>
`mstore` is short for Memory Store. <br>
`mstore8` is short for Memory Store 8-Bits or Memory Store 1-Byte. <br>
`sload` is short for Storage Load. <br>
`sstore` is short for Storage Store.

Depending on the location you want to store your value to or read your values from, you have to use one of these.

In the next chapters, we will head into reading from and writing data to our Solidity storage and memory locations.

This is where the fun begins. I hope you like risky fun.