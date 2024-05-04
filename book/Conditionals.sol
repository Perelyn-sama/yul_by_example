// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Conditionals {
    function IfElse(uint256 x) public pure returns (uint256 res) {
        assembly {
            if lt(x, 10) { res := 0 }
            if gt(x, 10) { res := 1 }
        }
        return res;
    }

    function switchFunction(uint256 x) public pure returns (bool isTrue) {
        assembly {
            switch lt(x, 79)
            // If true.
            case 1 { isTrue := 0x01 }
            // Otherwise.
            default { isTrue := 0x00 }
        }
    }
}
