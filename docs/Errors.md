# Errors

Errors are encoded the same way a calldata is encoded. First their 4 byte selector, then their arguments. And are read starting from the start of the selector with a size as large at their selector + encoded arguments.
```solidity
if lt(errorNumber, mainNumber) {
    mstore(0x00, errorSelector) // 4 bytes.
    mstore(0x04, storedNumberForError) // 32 bytes.
    revert(0x00, 0x24) // Reads 36 bytes.
}
```

Errors that do not want to return data simply revert with `(0x00, 0x00)`.
```solidity
if lt(errorNumber, mainNumber) {
    revert(0x00, 0x00)
}
```