// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Mapping {
    // Mapping from address to uint
    mapping(address => uint256) public myMap;

    function asmGet(address _addr) public view returns (uint256) {
        assembly {
            let memptr := mload(0x40)

            mstore(memptr, _addr)
            mstore(add(memptr, 0x20), 0x00)
            let addrBalanceSlot := keccak256(memptr, 0x40)
            let addrBalance := sload(addrBalanceSlot)

            mstore(0x00, addrBalance)
            return(0x00, 0x20)
        }
    }

    function asmSet(address _addr, uint256 _i) public {
        assembly {
            let memptr := mload(0x40)

            mstore(memptr, _addr)
            mstore(add(memptr, 0x20), 0x00)
            let addrBalanceSlot := keccak256(memptr, 0x40)
            let addrBalance := sload(addrBalanceSlot)

            sstore(addrBalanceSlot, _i)
        }
    }

    // TODO find a way to implement this in assembly 
    // function remove(address _addr) public {
    //     // Reset the value to the default value.
    //     delete myMap[_addr];
    // }
}
