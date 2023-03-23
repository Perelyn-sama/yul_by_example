// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// https://solidity-by-example.org/state-variables/
contract SimpleStruct {
    struct S {
        uint256 a; // Slot 0.
        uint256 b; // Slot 1.
        uint256 c; // Slot 2.
    }

    S public s;

    constructor() {
        s = S(12, 15, 18);
    }

    function getValue(uint8 slot) public view returns (uint256 value) {
        assembly {
            value := sload(slot)
            // 0 = 12
            // 1 = 15
            // 2 = 18
        }
    }
}

// https://solidity-by-example.org/state-variables/
contract PackedStruct {
    struct S {
        uint128 a; // Slot 0.
        uint64 b; // Slot 0.
        uint32 c; // Slot 0.
        uint16 d; // Slot 0.
        uint8 e; // Slot 0.
        uint8 f; // Slot 0.
    }

    S public s;

    constructor() {
        s = S(128, 64, 32, 16, 8, 4);
    }

    function viewPacking() public view returns (bytes32 value) {
        assembly {
            value := sload(0)
            // 0x0408001000000020000000000000004000000000000000000000000000000080
            // 0x04 08 0010 00000020 0000000000000040 00000000000000000000000000000080
            // f     e   d    c           b                       a
            // They are packed from most recent to least recent.
            // NOTE: a offset => 0.
            // NOTE: b offset => 16.
            // NOTE: c offset => 24.
            // NOTE: d offset => 28.
            // NOTE: e offset => 30.
            // NOTE: f offset => 31.
        }
    }

    // We are going to use indexes 0 - 5 for a to f respectively, just for fun.
    // This is to just show how they are retrieved from storage.
    function getFromPacking(uint8 val) public view returns (uint256) {
        assembly {
            let ourStruct := sload(0)

            if gt(val, 5) {
                revert (0, 0)
            }

            // How do I even comment this 💀?
            switch val
            case 0 {
                mstore(0x00, and(ourStruct, 0xf0f0ff0fffffff0fffffffffffffff0fffffffffffffffffffffffffffffffff))
            }
            case 1 {
                mstore(0x00, shr(mul(0x10, 0x08), and(ourStruct, 0xf0f0ff0fffffff0fffffffffffffffffffffffffffffffffffffffffffffff0f)))
            }
            case 2 {
                mstore(0x00, shr(mul(0x18, 0x08), and(ourStruct, 0xf0f0ff0fffffffffffffffffffffff0fffffffffffffffffffffffffffffff0f)))
            }
            case 3 {
                mstore(0x00, shr(mul(0x1c, 0x08), and(ourStruct, 0xf0f0ffffffffff0fffffffffffffff0fffffffffffffffffffffffffffffff0f)))
            }
            case 4 {
                mstore(0x00, shr(mul(0x1e, 0x08), and(ourStruct, 0xf0ffff0fffffff0fffffffffffffff0fffffffffffffffffffffffffffffff0f)))
            }
            case 5 {
                mstore(0x00, shr(mul(0x1f, 0x08), and(ourStruct, 0xfff0ff0fffffff0fffffffffffffff0fffffffffffffffffffffffffffffff0f)))
            }

            return (0x00, 0x20)
        }
    }
}