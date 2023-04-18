// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Bitwise.sol";

contract BitwiseTest is Test {
    Bitwise public bitwise;

    function setUp() public {
        bitwise = new Bitwise();
    }

    function testBitwise() public {
        assertEq(bitwise.shiftLeft(0x01, 1), 0x02);
        assertEq(bitwise.shiftRight(0x02, 1), 0x01);
        assertEq(bitwise.and(0x0F, 0x03), 0x03);
        assertEq(bitwise.or(0x0F, 0x30), 0x3F);
        assertEq(bitwise.xor(0x0F, 0x33), 0x3C);
        // assertEq(bitwise.not(0x0F), 0xFFFFFFFFFFFFFFF0);
    }
}
