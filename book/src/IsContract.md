# IsContract

This checks if an `address` is a contract or an `EOA` by looking at the size of the code. `EOA`s do not have code, `contracts` have code. The `extcodesize()` opcode returns the size of this code which is `0` for `EOA`s and `> 0` for `contracts`.