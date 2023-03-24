// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SendEther.sol";

contract SendEtherTest is Test {
    // Target Contract
    SendEther public sendEther;

    // Test params
    uint256 constant DEPLOY_AMOUNT = 100 ether;
    uint256 constant SENT_AMOUNT = 100 ether;

    // Actors
    address constant BOB = address(100);

    function setUp() public {
        sendEther = new SendEther{value: DEPLOY_AMOUNT}();
    }

    function testTransferEther() public {
        sendEther.transferEther(SENT_AMOUNT, BOB);
        assertEq(BOB.balance, SENT_AMOUNT);
    }
}
