// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Bitwise {
    function shiftLeft(uint256 num, uint256 bitsToShift) public pure returns (uint256) {
        assembly {
            mstore(0x00, shl(bitsToShift, num))
            return(0x00, 0x20)
        }
    }

    function shiftRight(uint256 num, uint256 bitsToShift) public pure returns (uint256) {
        assembly {
            mstore(0x00, shr(bitsToShift, num))
            return(0x00, 0x20)
        }
    }

    function and(uint256 num, uint256 andNum) public pure returns (uint256) {
        assembly {
            mstore(0x00, and(num, andNum))
            return(0x00, 0x20)
        }
    }

    function or(uint256 num, uint256 orNum) public pure returns (uint256) {
        assembly {
            mstore(0x00, or(num, orNum))
            return(0x00, 0x20)
        }
    }

    function xor(uint256 num, uint256 xorNum) public pure returns (uint256) {
        assembly {
            mstore(0x00, xor(num, xorNum))
            return(0x00, 0x20)
        }
    }

    function not(uint256 num) public pure returns (uint256) {
        assembly {
            mstore(0x00, not(num))
            return(0x00, 0x20)
        }
    }
}