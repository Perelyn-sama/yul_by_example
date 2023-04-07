// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

/// @notice Overflow checks will be added later in a different contract `SafeOperations`.
contract SafeOperations {
    function safeAdd(uint256 a, uint256 b) public pure returns (uint256) {
        assembly {
            if lt(add(a, b), a) {
                revert(0x00, 0x00)
            }
            mstore(0x00, add(a, b))
            return(0x00, 0x20)
        }
    }

    function safeSub(uint256 a, uint256 b) public pure returns (uint256) {
        assembly {
            if gt(b, a) {
                revert(0x00, 0x00)
            }
            mstore(0x00, sub(a, b))
            return(0x00, 0x20)
        }
    }

    function safeMul(uint256 a, uint256 b) public pure returns (uint256) {
        assembly {
            if eq(a, 0) {
                return(0x00, 0x20)
            }

            if eq(b, 0) {
                return(0x00, 0x20)
            }

            let c := mul(a, b)
            if iszero(eq(div(c, a), b)) { revert(0x00, 0x00) }

            mstore(0x00, c)
            return(0x00, 0x20)
        }
    }

    function safeDiv(uint256 a, uint256 b) public pure returns (uint256) {
        assembly {
            if eq(a, 0) {
                return(0x00, 0x20)
            }

            if eq(b, 0) {
                revert(0x00, 0x00)
            }

            let c := div(a, b)

            mstore(0x00, c)
            return(0x00, 0x20)
        }
    }
}