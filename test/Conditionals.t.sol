// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Conditionals.sol";

contract ConditionalsTest is Test {
    Conditionals public conditionals;

    function setUp() public {
        conditionals = new Conditionals();
    }

    function testIfElse() public {
        uint256 lesserThanTen = conditionals.IfElse(9);
        uint256 greaterThanTen = conditionals.IfElse(19);

        assertEq(lesserThanTen, 0);
        assertEq(greaterThanTen, 1);
    }

    function testSwitch() public {
        string memory lesserThanSeventyNine = vm.toString(conditionals.switchFunction(77));
        string memory greaterThanSeventyNine = vm.toString(conditionals.switchFunction(777));

        assertEq(lesserThanSeventyNine, "true");
        assertEq(greaterThanSeventyNine, "false");
    }
}
