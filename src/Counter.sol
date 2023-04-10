// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Counter {
    uint256 public count;

    function get() public view returns (uint256) {
        assembly {
            /**
            * @dev
            * The value of the variable `count` is stored at slot 0, which is known
            * by loading count.slot.
            * Once we have slot for `count` we then call an sload(slot_for_count) to
            * retrieve the value for count.
            * Once this is done, we store the value retrieved at location 0x00 in memory.
            */
            mstore(0x00, sload(count.slot))
            return(0x00, 0x20)
        }
    }

    function inc() public {
        assembly {
            let countSlot := count.slot
            let countNum := sload(countSlot)

            /**
            * @dev
            * We update the value at the `count` slot by incrementing the
            * current value at the slot by 1, then calling an sstore() to overwrite the
            * value at slot 0.
            * However, this doesn't check for overflows and underflows, so we must make sure that
            * we do not go beyond the limit for our type maximum before making the update.
            * We are working with uint256, so the max is 0x("ff" * 32).
            */
            if eq(countNum, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) {
                revert(0, 0)
            }
            sstore(countSlot, add(countNum, 1))
        }
    }

    function dec() public {
        assembly {
            let countSlot := count.slot
            let countNum := sload(countSlot)

            /**
            * @dev
            * We update the value at the `count` slot by decrementing the
            * current value at the slot by 1, then calling an sstore() to overwrite the
            * value at slot 0.
            * However, this doesn't check for overflows and underflows, so we must make sure that
            * we do not go below 0 before making the update.
            */
            if iszero(countNum) { revert(0, 0) }
            sstore(countSlot, sub(countNum, 1))
        }
    }
}
