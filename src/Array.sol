// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Array {
    // Declare array variables.
    uint256[3] fixedArray; // Elements stored @ slots 0, 1, 2.
    uint256[] dynamicArray; // Length stored @ slot 3, elements in slots keccak256(3) to (keccak256(3) + (length - 1)).
    uint8[] smallArray; // Slot keccak256(4).

    constructor() {
        // Initialize array variables.
        fixedArray = [10, 20, 30];
        dynamicArray = [100, 200, 300];
        smallArray = [1, 2, 3];
    }

    function readFixedArray(uint256 _index) public view returns (uint256 ret) {
        assembly {
            // Get slot of fixed array.
            let slot := fixedArray.slot

            // Fixed arrays are not stored at the locations of the hash of their slots.
            // This is because, the length of the array has already been defined and it's slots can be
            // mapped to it with no effects.
            // In this case, fixedArray elements are stored at indexes 0, 1 and 2.
            // The value at index 0 takes the first storage slot, followed by the subsequent indexes.
            // Info: https://rb.gy/yvbfwf.
            // Increment slot by the index we want to read.
            ret := sload(add(slot, _index))
        }
    }

    function readDynamicArray(uint256 _index) public view returns (uint256 ret) {
        assembly {
            // Get slot of the dynamic array.
            let slot := dynamicArray.slot

            // Store the value of the slot in memory at location 0x00.
            mstore(0x00, slot)

            // Hash the first 20 bytes of memory location 0x00 and assign it to the `location` variable.
            // We do this to get the sha256 hash of the slot which is the location for the dynamic array.
            let location := keccak256(0x00, 0x20)

            // Increment the location of the dynamic array by the _index we want to read.
            ret := sload(add(location, _index))
        }
    }

    function readDynamicArrayLength() public view returns (uint256 length) {
        assembly {
            length := sload(dynamicArray.slot)
        }
    }

    function readSmallArray() public view returns (bytes32 ret) {
        assembly {
            // Get slot of small array.
            let slot := smallArray.slot

            // Store the value of the slot in memory at location 0x00.
            mstore(0x00, slot)

            // Hash the first 20 bytes of memory location 0x00 and assign it to the `location` variable.
            let location := keccak256(0x00, 0x20)

            // Since small array is an array of uint8 we won't be able to read each index because they'll be packed into a 32 bytes word.
            ret := sload(location)
            // Returns 0x0...030201.
        }
    }

    function readSmallArrayIndex(uint256 _index) public view returns (uint256 value) {
        assembly {
            // Get slot of small array.
            let slot := smallArray.slot

            // Store the value of the slot in memory at location 0x00.
            mstore(0x00, slot)

            // Hash the first 20 bytes of memory location 0x00 and assign it to the `location` variable.
            let location := keccak256(0x00, 0x20)

            // Load the value of location on storage.
            // 0x0000000000000000000000000000000000000000000000000000000000030201
            let bytesValue := sload(location)

            let shifted

            switch _index
            case 0 {
                // Use bit masking to clear all indexes in bytes except the last byte.
                // 0x0000000000000000000000000000000000000000000000000000000000000001
                value := and(bytesValue, 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0f0ff)
            } case 1 {
                // Shift bytes to the right by 8 bits, or 1 byte,
                // this will push the second index to the end.
                // 0x0000000000000000000000000000000000000000000000000000000000000302
                shifted := shr(8, bytesValue)

                // Use bit masking to clear all indexes in bytes except the last byte.
                // 0x0000000000000000000000000000000000000000000000000000000000000002
                value := and(shifted, 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0ff)
            } case 2 {
                // Shift bytes by 16 bits, or 2 bytes, this will push the third index to the end.
                // 0x0000000000000000000000000000000000000000000000000000000000000003
                shifted := shr(16, bytesValue)

                // No point in bit masking, the bytes are already clear.
                value := shifted
            } default {
                value := 0x00
            }
        }
    }

    function pushToArray(uint256 num) public {
        assembly {
            mstore(0x00, 0x03)
            let location := keccak256(0x00, 0x20)
            let count := sload(0x03)

            sstore(0x03, add(count, 1))
            sstore(add(location, count), num)
        }
    }

    function popArray() public {
        assembly {
            mstore(0x00, 0x03)
            let location := keccak256(0x00, 0x20)
            let count := sload(0x03)

            if eq(count, 0) { revert(0x00, 0x00) }

            sstore(0x03, sub(count, 1))
            sstore(add(location, sub(count, 1)), 0x00)
        }
    }
}
