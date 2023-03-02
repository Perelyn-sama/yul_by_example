// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EtherWallet {
    address ownerSlot;
    bytes32 constant UnauthorizedSelector = 0x82b4290000000000000000000000000000000000000000000000000000000000;

    constructor() {
        assembly {
            sstore(ownerSlot.slot, caller())
        }  
           
    }

    receive() external payable {}

    function withdraw(uint _amount) external returns( uint out) {

        assembly{

            if iszero(eq(caller(), sload(ownerSlot.slot))) {
                mstore(0x00, UnauthorizedSelector)
                revert(0x00, 0x04)
            }

            out := call(gas(), caller(), _amount, 0, 0, 0, 0)
            if iszero(out) {
                mstore(0x00, 0x90b8ec18)
                revert(0x1c, 0x04)
            }

        }
    }

    function getBalance() external view returns (uint) {
        assembly{
            mstore(0x00, balance(caller()))
            return(0x00, 0x20)
        }
    }
}
