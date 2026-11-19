// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/access/Ownable.sol";

/// @title LottoCoin
/// @notice Simple ERC20 used for mint payments and lottery prizes.
contract LottoCoin is ERC20, Ownable {
    constructor() ERC20("LottoCoin", "LC") {
        _mint(msg.sender, 10_000 * 10 ** decimals());
    }

    /// @notice Owner can mint additional supply (educational convenience).
    function mint(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Zero address");
        _mint(to, amount);
    }
}
