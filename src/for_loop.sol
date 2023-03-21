// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Loop {
    function loop() public pure returns (uint256) {
        assembly {
            let x := 0
            for { let i := 0 } lt(i, 10) { i := add(i, 1) } {
                x := add(x, 1)
                // these next two lines would cancel each other out
                if eq(x, 5) { continue }
                if eq(x, 5) { break }
            }
            mstore(0x00, x)
            return(0x00, 0x20)
        }
    }
}