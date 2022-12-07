// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "ds-test/Test.sol";
import "../src/LottoCoin.sol";

contract LottoCoinTest is Test {
    LottoCoin public lottoCoin;
    address owner = address(1);
    address user = address(2);

    function setUp() public {
        lottoCoin = new LottoCoin();
    }

    //Initial Total Supply = 10000
    function testInitialTotalSupply() public {
        assertEq(lottoCoin.totalSupply(), 10000);
    }

    // Only owner can increase Total Suply
    function testIncreaseTotalSupply() public {
        vm.prank(owner);
        lottoCoin.increaseTotalSupply();
        assertEq(lottoCoin.totalSupply(), 11000);
    }

    // Only owner can increase Total Suply 2
    function testOnlyOwner() public {
        vm.prank(user);
        vm.expectRevert(bytes("Only the owner can increase total supply"));
        lottoCoin.increaseTotalSupply();
        assertEq(lottoCoin.totalSupply(), 10000);
    }

    // Tranfer test
    function testTransfer() public {
        vm.prank(owner);
        lottoCoin.transfer(user, 100);
        assertEq(lottoCoin.balanceOf(user), 100);
        assertEq(lottoCoin.balanceOf(owner), 9900);
    }

    // Test Approve
    function testApprove() public {
        vm.prank(user);
        lottoCoin.approve(owner, 10);
        assertEq(lottoCoin.allowance(user, owner), 10);
    }
}
