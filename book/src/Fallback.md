# Fallback

This is a function called when the `function selector` sent as a transaction to the contract doesn't match any function in that contract.

It is specified with a:
```solidity
fallback() external {}
```
OR
```solidity
fallback() external payable {}
```

In our [Fallback](https://github.com/Perelyn-sama/yul_by_example/blob/main/src/Fallback.sol) contract, it sends `1 Wei` to any caller.
