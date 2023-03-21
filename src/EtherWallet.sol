// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EtherWallet {
    address ownerSlot;
    bytes32 constant UnauthorizedSelector = 0x82b4290000000000000000000000000000000000000000000000000000000000;

    constructor() payable {
        assembly {
            // caller() returns the address of the msg.sender.
            // It is stored in the slot for `ownerSlot()`.
            sstore(ownerSlot.slot, caller())
        }
    }

    receive() external payable {}

    function withdraw(uint256 _amount) external {
        assembly {
            // If the address of msg.sender and address saved at ownerSlot is not equal.
            // It returns a 0 for false, and 1 for true. So if the returned value is 0, then it's false.
            // iszero(exp) checks if the exp returns a 0, and if it does, that expression is a false expression.
            // It reverts.
            if iszero(eq(caller(), sload(ownerSlot.slot))) {
                // Stores the 32 byte error at location 0x00.
                mstore(0x00, UnauthorizedSelector)
                // Reverts with the first 4 bytes of the error which is the selector.
                revert(0x00, 0x04)
            }
            // call sends `_amount` number of ether to the address passed as the second argument, `caller()`.
            let bool := call(gas(), caller(), _amount, 0, 0, 0, 0)
            // If the returned valud was false, then revert.
            if iszero(bool) {
                revert(0, 0)
            }
        }
    }

    function getBalance() external view returns (uint256) {
        assembly {
            // address() returns the address of the contract.
            // balance() returns the balance of a particular address.
            // mstore() has already been explained.
            mstore(0x00, balance(address()))
            return(0x00, 0x20)
        }
    }
}
