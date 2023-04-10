// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Enums {
    enum myEnum {
        NOTSTARTED,
        STARTED,
        STOPPED,
        DELETED
    }

    // Enums are uint8, They will be packed.
    myEnum myenum = myEnum.STOPPED; // Slot 0.

    function getEnumIndex() public view returns (myEnum e) {
        assembly {
            e := sload(0)
        }
    }
}