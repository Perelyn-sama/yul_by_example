// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Mapping {
    // Mapping from address to uint.
    mapping(address => uint256) myMap; // slot 0.

    function get(address _addr) public view returns (uint256) {
        assembly {
            // Assigns free memory pointer to `memptr`.
            let memptr := mload(0x40)

            // Store `_addr` in memory location `memptr`.
            mstore(memptr, _addr)

            // Store the myMap's slot in memory location memptr+0x20.
            mstore(add(memptr, 0x20), myMap.slot)

            // Hash the content in memory location `memptr` to `memptr+0x40`.
            // Assign hash to var `addrBalanceSlot`.
            let addrBalanceSlot := keccak256(memptr, 0x40)

            // Load the hash content stored in storage.
            // Assign the value to var `addrBalance`.
            let addrBalance := sload(addrBalanceSlot)

            // Store `addrBalance` in memory location `0x00`.
            mstore(0x00, addrBalance)

            // Return the content in memory position `0x00` to `0x00+0x20`.
            return(0x00, 0x20)
        }
    }

    function set(address _addr, uint256 _i) public {
        assembly {
            // Assigns free memory pointer to `memptr`.
            let memptr := mload(0x40)

            // Store `_addr` in memory location `memptr`.
            mstore(memptr, _addr)

            // Store the myMap's slot in memory location memptr+0x20.
            mstore(add(memptr, 0x20), myMap.slot)

            // Hash the content in memory location `memptr` to `memptr+0x40`.
            // Assign hash to var `addrBalanceSlot`.
            let addrBalanceSlot := keccak256(memptr, 0x40)

            // Store `_i` in storage slot `addrBalanceSlot`.
            sstore(addrBalanceSlot, _i)
        }
    }
}

contract NestedMapping {
    // Nested mapping (mapping from address to another mapping).
    mapping(address => mapping(uint256 => bool)) nested; // slot 0.

    function get(address _addr, uint256 _i) public view returns (bool) {
        assembly {
            // assigns free memory pointer to `memptr`.
            let memptr := mload(0x40)

            // Store `_addr` in memory location `memptr`.
            mstore(memptr, _addr)

            // Store the nested's slot in memory location memptr+0x20.
            mstore(add(memptr, 0x20), nested.slot)

            // Hash the content in memory location `memptr` to `memptr+0x40`.
            // Assign hash to var `innerHash`.
            let innerHash := keccak256(memptr, 0x40)

            // Store `_i` in memory location `memptr`.
            mstore(memptr, _i)

            // Store `innerHash` in memory location memptr+0x20.
            mstore(add(memptr, 0x20), innerHash)

            // Hash the content in memory location `memptr` to `memptr+0x40`.
            // Assign hash to var `slot`.
            let slotHash := keccak256(memptr, 0x40)

            // Load the content in storage slot `slotHash`.
            // Store the value in memory location `0x00`.
            mstore(0x00, sload(slotHash))

            // Return the content in memory position `0x00` to `0x00+0x20`.
            return(0x00, 0x20)
        }
    }

    function set(address _addr, uint256 _i, bool _bool) public {
        assembly {
            // Assigns free memory pointer to `memptr`.
            let memptr := mload(0x40)

            // Store `_addr` in memory location `memptr`.
            mstore(memptr, _addr)

            // Store the nested's slot in memory location memptr+0x20.
            mstore(add(memptr, 0x20), nested.slot)

            // Hash the content in memory location `memptr` to `memptr+0x40`.
            // Assign hash to var `innerHash`.
            let innerHash := keccak256(memptr, 0x40)

            // Store `_i` in memory location `memptr`.
            mstore(memptr, _i)

            // Store `innerHash` in memory location memptr+0x20.
            mstore(add(memptr, 0x20), innerHash)

            // Hash the content in memory location `memptr` to `memptr+0x40`.
            // Assign hash to var `slotHash`.
            let slotHash := keccak256(memptr, 0x40)

            // Store `_bool` in storage slot `slotHash`.
            sstore(slotHash, _bool)
        }
    }
}
