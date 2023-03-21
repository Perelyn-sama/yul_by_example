// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// https://solidity-by-example.org/first-app
contract Counter {
    // Slot 0.
    uint256 public count;

    // Function to get the current count.
    function get() public view returns (uint256) {
        assembly {
            // The value of the variable `count` is stored at slot 0, which is known
            // by loading count.slot.
            // Once we have slot for `count` we then call an sload(slot_for_count) to
            // retrieve the value for count.
            // Once this is done, we store the value retrieved at location 0x00 in memory.
            mstore(0x00, sload(count.slot))

            // Return the first 32 bytes starting from location 0x00.
            return(0x00, 0x20)
        }
    }

    // Function to increment count by 1
    function inc() public {
        assembly {
            // Assign count variable slot to countSlot.
            let countSlot := count.slot

            // We update the value at the `count` slot by incrementing the
            // current value at the slot by 1, then calling an sstore() to overwrite the
            // value at slot 0.
            // However, this doesn't check for overflows and underflows, so we must make sure that
            // we do not go beyond the limit for our type maximum before making the update.
            // We are working with uint256, so the max is 0x("ff" * 32).
            if eq(sload(countSlot), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) {
                revert(0, 0)
            }
            sstore(countSlot, add(sload(countSlot), 1))
        }
    }

    // Function to decrement count by 1
    function dec() public {
        assembly {
            // Assign count variable slot to countSlot.
            let countSlot := count.slot

            // We update the value at the `count` slot by decrementing the
            // current value at the slot by 1, then calling an sstore() to overwrite the
            // value at slot 0.
            // However, this doesn't check for overflows and underflows, so we must make sure that
            // we do not go below 0 before making the update.
            if iszero(sload(countSlot)) {
                revert(0, 0)
            }
            sstore(countSlot, sub(sload(countSlot), 1))
        }
    }
}
