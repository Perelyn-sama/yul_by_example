// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Array {
    // Declare array variables
    uint256[3] fixedArray;
    uint256[] dynamicArray;
    uint8[] smallArray;

    constructor() {
        // initialize array variables
        fixedArray = [10, 20, 30];
        dynamicArray = [100, 200, 300];
        smallArray = [1, 2, 3];
    }

    function readFixedArray(uint256 _index) public view returns (uint256 ret) {
        assembly {
            // get slot of fixed array
            let slot := fixedArray.slot

            // increment slot by the index we want to read
            ret := sload(add(slot, _index))
        }
    }

    function readDynamicArray(uint256 _index) public view returns (uint256 ret) {
        assembly {
            // get slot of dynamic array
            let slot := dynamicArray.slot

            // store in memory slot at 0x00
            mstore(0x00, slot)

            // hash 0x00 to 0x20 on memory and assign it to locaton varible
            // we do this to get the sha256 hash of slot which is the location for the dynamic array
            let location := keccak256(0x00, 0x20)

            // increment the location of the dynamic array by the _index we want to read
            ret := sload(add(location, _index))
        }
    }

    function readDynamicArrayLength() public pure returns (uint256 length) {
        assembly {
            length := dynamicArray.slot
        }
    }

    function readSmallArray() public view returns (bytes32 ret) {
        assembly {
            // get slot of small array
            let slot := smallArray.slot

            // store in memory slot at 0x00
            mstore(0x00, slot)

            // hash 0x00 to 0x20 on memory 
            let location := keccak256(0x00, 0x20)

            // since small array is an array of uint8 we won't be able to read each index because they'll be packed into a 32 bytes word 
            ret := sload(add(location, 0))
        }
    }

    function readSmallArrayIndex(uint256 _index) public view returns (uint256 value) {
        assembly {
            // get slot of small array
            let slot := smallArray.slot

             // store in memory slot at 0x00
            mstore(0x00, slot)

            // hash 0x00 to 0x20 on memory 
            let location := keccak256(0x00, 0x20)

            // load the value of location on storage
            // 0x0000000000000000000000000000000000000000000000000000000000030201
            let bytes := sload(add(location, 0))

            let shifted

            switch _index
            case 0 {
                // shift bytes by 0, this will do nothing 
                shifted := shr(0, bytes)

                // use bit masking to clear the other indexes in bytes 
                // 0x0000000000000000000000000000000000000000000000000000000000000001
                value := and(shifted, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000ff)
            }
            case 1 {
                // shift bytes by 8, this will push the second index to the end
                // 0x0000000000000000000000000000000000000000000000000000000000000302
                shifted := shr(8, bytes)

                // use bit masking to clear the other indexes in bytes 
                // 0x0000000000000000000000000000000000000000000000000000000000000002
                value := and(shifted, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff)
            }
            case 2 {
                // shift bytes by 16, this will push the third index to the end
                // 0x0000000000000000000000000000000000000000000000000000000000000003
                shifted := shr(16, bytes)

                // no point in bit masking, the bytes are already clear
                value := shifted
            }
        }
    }
}
