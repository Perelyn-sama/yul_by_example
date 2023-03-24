// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ForLoop.sol";

contract ForLoopTest is Test {
    Loop public loop;

    function setUp() public {
        loop = new Loop();
    }

    function testLoop() public {
        emit log_uint(loop.loop());
        assertEq(loop.loop(), 10);
    }
}
