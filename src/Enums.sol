// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Enums {
    enum myEnum {
        NOTSTARTED, // Index 0,
        STARTED, // Index 1,
        STOPPED, // Index 2,
        DELETED // Index 3
    }

    // Enums are uint8, They will be packed.
    myEnum myenum = myEnum.STOPPED; // Slot 0.

    function getEnumIndex() public view returns (myEnum e) {
        assembly {
            e := sload(0)
        }
    }
}