// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// https://solidity-by-example.org/first-app
contract Counter {
    // slot 0
    uint256 public count;

    // Function to get the current count
    function get() public view returns (uint256) {
        uint256 count;
        assembly {
            count := sload(0)
        }
        return count;
    }

    // Function to increment count by 1
    function inc() public {
        assembly {
            sstore(0, add(sload(0), 1))
        }
    }

    // Function to decrement count by 1
    function dec() public {
        // yul does not prevent underflow/overflow so this will work
        assembly {
            sstore(0, sub(sload(0), 1))
        }
    }
}
