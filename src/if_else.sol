// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract IfElse {
    function foo(uint x) public pure returns (uint res) {
        assembly {
            if lt(x, 10){
                res := 0
            }
            if lt(x, 20){
                res := 1
            }
            res := 2
        }
        return res;
    }

}
