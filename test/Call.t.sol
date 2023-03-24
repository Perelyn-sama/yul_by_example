// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Call.sol";

contract CallTest is Test {
    CalledContract public calledContract;
    CallerContract public callerContract;

    function setUp() public {
        calledContract = new CalledContract();
        callerContract = new CallerContract(address(calledContract));
    }

    // FIXME Add fuzz testing
    function testCaller() public {
        uint256 expected_result = 9;

        // set `number` in CalledContract to 9 from CallerContract
        callerContract.callContract(expected_result);

        // get `number` in CalledContract with it's getNumber function
        uint256 result = calledContract.getNumber();

        // assertt
        assertEq(result, expected_result);
    }
}
