// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Mapping {
    // Mapping from address to uint
    mapping(address => uint256) public myMap; // 0

    function get(address _addr) public view returns (uint256) {
        assembly {
            let memptr := mload(0x40) // 0x80

            mstore(memptr, _addr) // Store the address @ 0x80.
            mstore(add(memptr, 0x20), 0x00) // Store 0 @ 0xa0.
            let addrBalanceSlot := keccak256(memptr, 0x40) // keccak256(0x80, 0x40)
            let addrBalance := sload(addrBalanceSlot)

            mstore(0x00, addrBalance)
            return(0x00, 0x20)
        }
    }

    function set(address _addr, uint256 _i) public {
        assembly {
            let memptr := mload(0x40)

            mstore(memptr, _addr)
            mstore(add(memptr, 0x20), 0x00)
            let addrBalanceSlot := keccak256(memptr, 0x40)
            let addrBalance := sload(addrBalanceSlot)

            sstore(addrBalanceSlot, _i)
        }
    }
}

contract NestedMapping {
    // Nested mapping (mapping from address to another mapping)
    mapping(address => mapping(uint256 => bool)) public nested;

    function get(address _addr, uint256 _i) public view returns (bool) {
        assembly {
            let memptr := mload(0x40)

            mstore(memptr, _addr)
            mstore(add(memptr, 0x20), 0x00)
            let innerHash := keccak256(memptr, 0x40)

            mstore(memptr, _i)
            mstore(add(memptr, 0x20), innerHash)
            let slot := keccak256(memptr, 0x40)

            mstore(0x00, sload(slot))
            return(0x00, 0x20)
        }
    }

    function set(address _addr1, uint256 _i, bool _boo) public {
        assembly {
            let memptr := mload(0x40)

            mstore(memptr, _addr1)
            mstore(add(memptr, 0x20), 0x00)
            let innerHash := keccak256(memptr, 0x40)

            mstore(memptr, _i)
            mstore(add(memptr, 0x20), innerHash)
            let slot := keccak256(memptr, 0x40)

            sstore(slot, _boo)
        }
    }
}
