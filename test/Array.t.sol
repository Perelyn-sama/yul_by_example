// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../src/Array.sol";

contract ArrayTest is Test {
    Array public array;

    function setUp() public {
        array = new Array();
    }

    function testReadFixedArray() public {
        // fixedArray - [10, 20, 30]
        uint256 ret0 = array.readFixedArray(0);
        uint256 ret1 = array.readFixedArray(1);
        uint256 ret2 = array.readFixedArray(2);
        assertEq(ret0, 10);
        assertEq(ret1, 20);
        assertEq(ret2, 30);
    }

    function testreadDynamicArray() public {
        // fixedArray - [100, 200, 300]
        uint256 ret = array.readDynamicArray(0);
        emit log_uint(ret);
        assertEq(ret, 100);
    }

    function testReadSmallArrayIndex() public {
        // smallArray - [1, 2, 3];
        uint256 ret0 = array.readSmallArrayIndex(0);
        assertEq(ret0, 1);
        emit log_named_uint("index 0", ret0);
        emit log_named_bytes32("index 0", bytes32(ret0));

        uint256 ret1 = array.readSmallArrayIndex(1);
        assertEq(ret1, 2);
        emit log_named_uint("Index 1", ret1);
        emit log_named_bytes32("Index 1", bytes32(ret1));

        uint256 ret2 = array.readSmallArrayIndex(2);
        assertEq(ret2, 3);
        emit log_named_uint("Index2", ret2);
        emit log_named_bytes32("Index 2", bytes32(ret2));
    }

    function testReadSmallArray() public {
        // smallArray - [1, 2, 3]
        bytes32 ret = array.readSmallArray();
        emit log_bytes32(ret);
        assertEq(0x0000000000000000000000000000000000000000000000000000000000030201, ret);
    }
}
