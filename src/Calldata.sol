// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

/// @notice The functions in this contract will be called by the
///         `CallerContract` via means of `call` or `staticcall`.
/// @notice Refer to Calldata.md to see how encodings work.
contract CalledContract {
    // Basic: Take a number and return the sum of that and a fixed value.
    function add(uint256 i) public pure returns (uint256) {
        return i + 78;
    }

    function multiply(uint8 i, uint8 j) public pure returns (uint256) {
        return uint256(i * j);
    }

    function arraySum(uint256[] calldata arr) public pure returns (uint256) {
        uint256 len = arr.length;
        uint256 sum;

        for (uint256 i; i != len; ) {
            sum = sum + arr[i];
            unchecked { ++i; }
        }

        return sum;
    }
}


/// @notice CallerContract.
///         It calls the `CalledContract`.
contract CallerContract {
    address _calledContract;
    constructor() {
        _calledContract = address(new CalledContract());
    }

    /// @notice add: 1003e2d2.
    function callAdd(uint256 num) public view returns (uint256) {
        address calledContract = _calledContract;

        assembly {
            mstore(0x00, 0x1003e2d2)
            mstore(0x20, num)

            let success := staticcall(gas(), calledContract, 0x1c, 0x24, 0x00, 0x00)

            if iszero(success) {
                revert (0x00, 0x00)
            }

            returndatacopy(0x00, 0x00, returndatasize())
            return(0x00, returndatasize())
        }
    }

    /// @notice multiply: 6a7a8e0b
    function callMultiply(uint8 num1, uint8 num2) public view returns (uint256) {
        address calledContract = _calledContract;

        assembly {
            mstore(0x80, 0x6a7a8e0b)
            mstore(0xa0, num1)
            mstore(0xc0, num2)

            let success := staticcall(gas(), calledContract, 0x9c, 0x44, 0x00, 0x00)

            if iszero(success) {
                revert (0x00, 0x00)
            }

            returndatacopy(0x00, 0x00, returndatasize())
            return(0x00, returndatasize())
        }
    }

    /// @notice arraySum: 7c2b11cd
    function callArraySum(
        uint256 num1,
        uint256 num2,
        uint256 num3,
        uint256 num4
    ) public view returns (uint256)
    {
        address calledContract = _calledContract;

        assembly {
            mstore(0x80, 0x7c2b11cd)
            mstore(0xa0, 0x20)
            mstore(0xc0, 0x04)
            mstore(0xe0, num1)
            mstore(0x0100, num2)
            mstore(0x0120, num3)
            mstore(0x0140, num4)

            let success := staticcall(gas(), calledContract, 0x9c, 0xc4, 0x00, 0x00)

            if iszero(success) {
                revert (0x00, 0x00)
            }

            returndatacopy(0x00, 0x00, returndatasize())
            return(0x00, returndatasize())
        }
    }
}