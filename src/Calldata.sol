// SPDX-License-Identifier: MIT
pragma solidity =0.8.15;

/// @notice The functions in this contract will be called by the
///         `CallerContract` via means of `call` or `staticcall`.
contract CalledContract {
    // Basic: Take a number and return the doubled value.
    function add(uint256 i) public pure returns (uint256) {
        return i * 2;
    }
}


/// @notice CallerContract.
///         It calls the `CalledContract`.
contract CallerContract {
    /// @notice add: 1003e2d2.
    function callAdd(uint256 num) public pure returns (uint256) {
        assembly {

        }
    }
}