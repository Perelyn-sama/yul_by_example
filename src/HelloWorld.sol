// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
// https://solidity-by-example.org/hello-world

contract HelloWorld {
    function greet() external pure returns (string memory) {
        assembly {
            // Assign the string to var `greet`
            // "Hello World!" => 0x48656c6c6f20576f726c64210000000000000000000000000000000000000000.
            let greet := 0x48656c6c6f20576f726c64210000000000000000000000000000000000000000
            // Store the string offset in mem[0x00].
            // This is an ABI requirement, 0x20 must be stored at any chosen offset.
            mstore(0x00, 0x20)
            // Store the length of the string in mem[offset + 32 bytes].
            mstore(0x20, 0x0c) // 0x0c = 12, length of "Hello World!".
            // Store the string in mem[offset + 64 bytes].
            mstore(0x40, greet)
            // Returns the bytes from mem[offset to offset+size]
            return(0x00, 0x60)
        }
    }
}
