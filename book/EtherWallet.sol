// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract EtherWallet {
    address owner;
    bytes4 constant UnauthorizedSelector = 0x82b42900;

    constructor() payable {
        assembly {
            // caller() returns the address of the msg.sender.
            // It is stored in the slot for `owner()`.
            sstore(owner.slot, caller())
        }
    }

    receive() external payable {}

    function getBalance() external view returns (uint256) {
        assembly {
            // selfbalance() returns address of this contract.
            mstore(0x00, selfbalance())
            return(0x00, 0x20)
        }
    }

    function withdraw(uint256 _amount) external {
        assembly {
            // If the address of msg.sender and address saved at owner is not equal.
            // It returns a 0 for false, and 1 for true. So if the returned value is 0, then it's false.
            // iszero(exp) checks if the exp returns a 0, and if it does, that expression is a false expression.
            // It reverts.
            if iszero(eq(caller(), sload(0x00))) {
                // Stores the 32 byte error at location 0x00.
                mstore(0x00, UnauthorizedSelector)
                // Reverts with the first 4 bytes of the error which is the selector.
                revert(0x00, 0x04)
            }
            // call sends `_amount` number of ether to the address passed as the second argument, `caller()`.
            let sent := call(gas(), caller(), _amount, 0x00, 0x00, 0x00, 0x00)
            // If the returned value is false, then revert.
            if iszero(sent) {
                revert(0x00, 0x00)
            }
        }
    }
}
