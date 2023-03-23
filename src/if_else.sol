// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract IfElse {
    function foo(uint256 x) public pure returns (uint256 res) {
        assembly {
            // There are no parentheses in the if statements, and there are no elses, rather, use switch.
            if lt(x, 10) { res := 0 }
            if gt(x, 10) { res := 1 }
        }
        return res;
    }

    function switchFunction(uint256 x) public pure returns (bool isTrue) {
        assembly {
            switch lt(x, 79)
            // If true.
            case 1 {
                isTrue := 0x00000000000000000000000000000000000000000000000000000000000000000001
            }
            // Otherwise.
            default {
                isTrue := 0x00000000000000000000000000000000000000000000000000000000000000000000
            }
        }
    }
}
