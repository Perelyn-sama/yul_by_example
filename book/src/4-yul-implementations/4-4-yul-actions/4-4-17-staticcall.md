# `staticcall`

---

The difference between `staticcall` and `delegatecall` is that `staticcall` makes calls to only `view` or `pure` functions. A `staticcall` will revert if it makes a call to a function in a smart contract that changes the state of that smart contract.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract CalledContract {
    struct Data {
        uint128 x;
        uint128 y;
    }

    string public myString;
    uint256 public bigSum;

    fallback() external {}

    function add(uint256 i) public pure returns (uint256) {
        return i + 78;
    }

    function multiply(uint8 i, uint8 j) public pure returns (uint256) {
        return uint256(i * j);
    }

    function arraySum(uint256[] calldata arr) public pure returns (uint256) {
        uint256 len = arr.length;
        uint256 sum;

        for (uint256 i; i != len; i++ ) {
            sum = sum + arr[i];
        }

        return sum;
    }

    function setString(string calldata str) public {
        if (bytes(str).length > 31) revert();
        myString = str;
    }

    function structCall(Data memory data) public {
        bigSum = uint256(data.x + data.y);
    }
}

contract CallerContract {
    address public _calledContract;
    
    constructor() {
        _calledContract = address(new CalledContract());
    }

    /// @notice add: 1003e2d2.
    function callAdd(uint256 num) public view returns (uint256) {
        address calledContract = _calledContract;

        assembly {
            mstore(0x80, 0x1003e2d2)
            mstore(0xa0, num)

            let success := staticcall(gas(), calledContract, 0x9c, 0x24, 0x00, 0x00)

            if iszero(success) {
                revert (0x00, 0x00)
            }

            returndatacopy(0x80, 0x00, returndatasize())
            return(0x80, returndatasize())
        }
    }

    /// @notice multiply: 6a7a8e0b.
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

            returndatacopy(0x80, 0x00, returndatasize())
            return(0x80, returndatasize())
        }
    }

    /// @notice arraySum: 7c2b11cd.
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

            returndatacopy(0x80, 0x00, returndatasize())
            return(0x80, returndatasize())
        }
    }

    /// @notice setString: 7fcaf666.
    function callSetString(string calldata str) public {
        uint8 len = uint8(bytes(str).length);
        if (len > 31) revert();

        address calledContract = _calledContract;
        bytes memory strCopy = bytes(str);

        assembly {
            mstore(0x0200, mload(add(strCopy, 0x20)))

            mstore(0x80, 0x7fcaf666)
            mstore(0xa0, 0x20)
            mstore(0xc0, len)
            mstore(0xe0, mload(0x0200))

            let success := call(gas(), calledContract, 0, 0x9c, 0x64, 0x00, 0x00)
        }
    }

    function getNewString() public view returns (string memory) {
        return CalledContract(_calledContract).myString();
    }

    function callStructCall(uint128 num1, uint128 num2) public {
        address calledContract = _calledContract;
        bytes4 _selector = CalledContract.structCall.selector;

        assembly {
            mstore(0x9c, _selector)
            mstore(0xa0, num1)
            mstore(0xc0, num2)

            let success := call(gas(), calledContract, 0, 0x9c, 0x44, 0x00, 0x00)
        }
    }

    function getBigSum() public view returns (uint256) {
        return CalledContract(_calledContract).bigSum();
    }
}
```

`returndatacopy(a, b, c)` copies the data returned from a function call to location `a` in memory. But that's not all, it tells the EVM to copy starting from `b` and copy as much as `c` in bytes. In other words, "Start from position `b` in the returned data and copy `c` bytes of the returned data to memory location `a`.".

`returndatasize()` returns the size of the data returned from a function call.