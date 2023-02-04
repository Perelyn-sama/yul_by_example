// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.17 and less than 0.9.0
pragma solidity ^0.8.17;

// https://solidity-by-example.org/hello-world
contract HelloWorld {
    function Greet() external pure returns (string memory) {
        bytes32 greet;
        assembly {
            greet := "Hello World!"
        }
        return string(abi.encode(greet));
    }
}
