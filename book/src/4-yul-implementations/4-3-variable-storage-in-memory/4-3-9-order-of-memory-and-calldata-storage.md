# Order Of Memory And `Calldata` Storage

In a situation where we have a group of types to be stored in memory or `calldata`, say a function like this:

```solidity
function functionName(uint8 value1, string memory stringVal, address[] memory addresses) {}
```

What's the proper way to encode this in `calldata`? To find out, the Solidity team have provided a fantastic material [in this section of their docs](https://docs.soliditylang.org/en/latest/abi-spec.html#) to help with that.