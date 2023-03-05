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

    function withdraw(uint256 _amount) external {
        assembly {
            if iszero(eq(caller(), sload(ownerSlot.slot))) {
                mstore(0x00, UnauthorizedSelector)
                revert(0x00, 0x04)
            }

            pop(call(gas(), caller(), _amount, 0, 0, 0, 0))
        }
    }

    function getBalance() external view returns (uint256) {
        assembly {
            mstore(0x00, balance(address()))
            return(0x00, 0x20)
        }
    }
}
