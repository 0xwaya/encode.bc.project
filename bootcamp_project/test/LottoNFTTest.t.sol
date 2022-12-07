// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/LottoNFT.sol";
import "../src/LottoCoin.sol";

contract LottoNFTTest is Test {
    LottoNFT public lottoNFT;
    LottoCoin public lottoCoin;
    address owner = address(1);
    address user = address(2);

    function setUp() public {
        vm.startPrank(owner);
        lottoCoin = new LottoCoin(1000);
        lottoNFT = new LottoNFT(address(lottoCoin));
        vm.stopPrank();
    }

    function writeTokenBalance(
        address who,
        address token,
        uint256 amt
    ) internal {
        stdstore
            .target(lottoCoin)
            .sig(IERC20(lottoCoin).balanceOf.selector)
            .with_key(who)
            .checked_write(amt);
    }

    function testMint() public {
        vm.startPrank(user);
        writeTokenBalance(user, address(lottoCoin), 100);
        lottoCoin.approve(address(lottoNFT), 10);
        lottoNFT.mint();
    }

    // mint fails due to insufficient approve funds
    function testFailMint() public {
        vm.startPrank(user);
        writeTokenBalance(user, address(lottoCoin), 100);
        lottoCoin.approve(address(lottoNFT), 5);
        lottoNFT.mint();
    }

    // mint fails due to insufficient balance
    function testFailMint() public {
        vm.startPrank(user);
        writeTokenBalance(user, address(lottoCoin), 5);
        lottoCoin.approve(address(lottoNFT), 10);
        lottoNFT.mint();
    }
}
