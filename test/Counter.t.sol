// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
    }

    function testCounter() public {
        uint256 initialState = counter.get();
        assertEq(initialState, 0);

        counter.inc();
        uint256 stateAfterInc = counter.get();
        assertEq(stateAfterInc, 1);

        counter.dec();
        uint256 stateAfterDec = counter.get();
        assertEq(stateAfterDec, 0);
    }
}
