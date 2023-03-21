// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.17 and less than 0.9.0
pragma solidity ^0.8.17;

// https://solidity-by-example.org/hello-world
contract HelloWorld {
    function Greet() external pure returns (string memory) {
        assembly {
            // Assign the string to var `greet`
            let greet := "Hello World!"
            // Store the string offset in mem[0x00]
            mstore(0x00, 0x20)
            // Store the length of the string in mem[0x20]
            mstore(0x20, 0x0c)
            // Store the string in mem[0x40]
            mstore(0x40, greet)
            // Returns the bytes from mem[offset to offset+size]
            return(0x00, 0x60)
        }
    }
}
