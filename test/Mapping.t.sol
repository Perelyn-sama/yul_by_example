// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Mapping.sol";

contract MappingTest is Test {
    Mapping public mappingContract;
    NestedMapping public nestedMapping;

    address public addr = address(100);
    uint256 public value = 10e6;
    bool public boolean = true;

    function setUp() public {
        mappingContract = new Mapping();
        nestedMapping = new NestedMapping();
    }

    function testMapping() public {
        mappingContract.set(addr, value);
        assertEq(mappingContract.get(addr), value);
    }

    function testNestedMapping() public {
        nestedMapping.set(addr, value, boolean);
        assertEq(nestedMapping.get(addr, value), boolean);
    }
}
