// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// https://solidity-by-example.org/first-app
contract Counter {
    // slot 0
    uint256 public count;

    // Function to get the current count
    function get() public view returns (uint256) {
        assembly {
            // assign count variable slot to countSlot
            let countSlot := count.slot

            // store the value countSlot to memory at 0x00
            // sload to load the value in countSlot
            // mstore to store the value in countSlot to 0x00
            mstore(0x00, sload(countSlot))

            // return first 32 bytes
            return(0x00, 0x20)
        }
    }

    // Function to increment count by 1
    function inc() public {
        assembly {
            // assign count variable slot to countSlot
            let countSlot := count.slot

            // Increment the value in countSlot with 1 - add(sload())
            // then store the result in storage at countSlot - sstore
            sstore(countSlot, add(sload(countSlot), 1))
        }
    }

    // Function to decrement count by 1
    function dec() public {
        // yul does not prevent underflow/overflow so this will work when count is zero
        assembly {
            // assign count variable slot to countSlot
            let countSlot := count.slot

            // Decrement the value in countSlot with 1 - add(sload())
            // then store the result in storage at countSlot - sstore
            sstore(countSlot, sub(sload(countSlot), 1))
        }
    }
}
