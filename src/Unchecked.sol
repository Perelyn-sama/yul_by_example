// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

/// @notice Overflow checks will be added later in a different contract `UncheckedRemedy`.
contract Unchecked {
    function uncheckedAdd(uint256 a, uint256 b) public pure returns (uint256) {
        assembly {
            mstore(0x00, add(a, b))
            return(0x00, 0x20)
        }
    }

    function uncheckedSub(uint256 a, uint256 b) public pure returns (uint256) {
        assembly {
            mstore(0x00, sub(a, b))
            return(0x00, 0x20)
        }
    }

    function uncheckedMul(uint256 a, uint256 b) public pure returns (uint256) {
        assembly {
            mstore(0x00, mul(a, b))
            return(0x00, 0x20)
        }
    }

    function uncheckedDiv(uint256 a, uint256 b) public pure returns (uint256) {
        assembly {
            mstore(0x00, add(a, b))
            return(0x00, 0x20)
        }
    }
}