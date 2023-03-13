// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/EtherWallet.sol";

contract EtherWalletTest is Test {

    // Target Contract
    EtherWallet public etherWallet;

    // Test params
    uint256 constant DEPLOY_AMOUNT = 20 ether;

    // Actors
    address constant CUSTOM_DEPLOYER = address(100);
    address constant UNAUTHORIZED_DEPLOYER = address(200);

    function setUp() public {
        // set balance of CUSTOM_DEPLOYER to 100 ether
        deal(CUSTOM_DEPLOYER, 100 ether);

        // set msg.sender to CUSTOM_DEPLOYER
        // then deploy contract with 20 ether 
        vm.prank(CUSTOM_DEPLOYER);
        etherWallet = new EtherWallet{value: DEPLOY_AMOUNT}();
    }

    function testWithdraw() public {
        // Check if getBalance function works
        assertEq(etherWallet.getBalance(), DEPLOY_AMOUNT);

        // set msg.sender to CUSTOM_DEPLOYER
        // then withdraw 20 ether from etherWallet
        vm.prank(CUSTOM_DEPLOYER);
        etherWallet.withdraw(20 ether);

        // check if withdraw function works
        assertEq(CUSTOM_DEPLOYER.balance, 100 ether);
    }

    // is not supposed to work
    function testFailUnauthorizedWithdraw() public {
        // set msg.sender to UNAUTHORIZED_DEPLOYER
        // then withdraw 20 ether from etherWallet
        // will fail because UNAUTHORIZED_DEPLOYER is not deployer
        vm.prank(UNAUTHORIZED_DEPLOYER);
        etherWallet.withdraw(20 ether);
    }
}
