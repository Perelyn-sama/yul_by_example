// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

/// @notice Operations in Assembly overflow!!
contract Functions {
    function withoutAssemblyReturn(uint256 a, uint256 b) public view returns (uint256) {
        // Assembly function without a return value.
        assembly {
            function sum(num1, num2) {
                mstore(0x00, add(num1, num2))
            }
            sum(a, b)
            return(0x00, 0x20)
        }
    }

    function withAssemblyReturn(uint256 a, uint256 b) public view returns (uint256) {
        // Assembly function with a return value.
        assembly {
            function sum(num1, num2) -> total {
                total := add(num1, num2)
            }
            mstore(0x00, sum(a, b))
            return(0x00, 0x20)
        }
    }
}