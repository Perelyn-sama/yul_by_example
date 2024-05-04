// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

/// @notice Checks if an address is a contract or not.
contract IsContract {
    function isContract(address _address) public view returns (bool _isContract) {
        assembly {
            let size := extcodesize(_address)

            switch size
            case 0 {
                _isContract := 0x00
            } default {
                _isContract := 0x01
            }
        }
    }
}