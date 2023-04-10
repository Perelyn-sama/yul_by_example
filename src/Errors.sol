// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Errors {
    // keccak256(NumberLessThan6(uint256))
    bytes4 constant errorSelector = 0x8205edea;
    uint8 private constant errorNumber = 4;
    uint8 private constant mainNumber = 6;
    uint8 private constant storedNumberForError = 15;

    function revertWithOutErrorMessage() public pure {
        assembly {
            if lt(errorNumber, mainNumber) {
                revert(0x00, 0x00)
            }
        }
    }

    function revertWithErrorMessage() public pure {
        assembly {
            if lt(errorNumber, mainNumber) {
                mstore(0x00, errorSelector) // 4 bytes.
                mstore(0x04, storedNumberForError) // 32 bytes.
                revert(0x00, 0x24) // Reads 36 bytes.
            }
        }
    }
}