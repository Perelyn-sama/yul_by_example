// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract SendEther {

    constructor() payable {}
    
    function transferEther(uint256 amount, address to) external {
        assembly {
            let s := call(gas(), to, amount, 0, 0, 0, 0)
            if iszero(s) {
                revert(0, 0)
            }
        }
    }

}