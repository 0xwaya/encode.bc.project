// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin-contracts/access/Ownable.sol";
import "erc721a/contracts/IERC721A.sol";
import "openzeppelin-contracts/token/ERC20/IERC20.sol";
import "../@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "openzeppelin-contracts/utils/structs/EnumerableSet.sol";

/// @title Lotto
/// @notice Chainlink VRF lottery that pays a random NFT holder in LottoCoin.
/// @dev Educational project. VRF addresses are Goerli-era.
contract Lotto is VRFConsumerBase, Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    bytes32 internal keyHash;
    uint256 internal fee;

    address public winner;
    IERC721A public nftAddress;
    IERC20 public coinAddress;
    uint256 public winningAmount = 10;

    EnumerableSet.AddressSet private entrants;

    event PrizeRequested(bytes32 indexed requestId);
    event WinnerSelected(address indexed winner, uint256 amount);
    event EntrantsUpdated(uint256 count);

    constructor()
        VRFConsumerBase(
            0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D, // VRF Coordinator (Goerli)
            0x326C977E6efc84E512bB9C30f76E30c160eD06FB // LINK Token (Goerli)
        )
    {
        keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
        fee = 0.1 ether; // 0.1 LINK
    }

    /// @notice Called by LottoNFT to start a draw.
    function sendPrize() external returns (bytes32 requestId) {
        require(msg.sender == address(nftAddress), "Only NFT contract");
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK");
        require(entrants.length() > 0 || nftAddress.totalSupply() > 0, "No entrants");

        requestId = requestRandomness(keyHash, fee);
        emit PrizeRequested(requestId);
    }

    function fulfillRandomness(bytes32, uint256 randomness) internal override {
        _rebuildEntrants();
        require(entrants.length() > 0, "No entrants after rebuild");

        uint256 idx = randomness % entrants.length();
        winner = entrants.at(idx);

        uint256 amount = winningAmount;
        require(coinAddress.balanceOf(address(this)) >= amount, "Insufficient prize balance");
        require(coinAddress.transfer(winner, amount), "Prize transfer failed");

        emit WinnerSelected(winner, amount);
    }

    function getWinner() external view returns (address) {
        return winner;
    }

    function getEntrants() external view returns (address[] memory) {
        return entrants.values();
    }

    function setNftAddress(address _nftAddress) external onlyOwner {
        require(_nftAddress != address(0), "Zero address");
        nftAddress = IERC721A(_nftAddress);
    }

    function setCoinAddress(address _coinAddress) external onlyOwner {
        require(_coinAddress != address(0), "Zero address");
        coinAddress = IERC20(_coinAddress);
    }

    function setWinningAmount(uint256 _amount) external onlyOwner {
        winningAmount = _amount;
    }

    function _rebuildEntrants() private {
        // Clear previous set
        while (entrants.length() > 0) {
            entrants.remove(entrants.at(0));
        }

        IERC721A tokenContract = nftAddress;
        uint256 supply = tokenContract.totalSupply();

        for (uint256 i = 0; i < supply; i++) {
            address holder = tokenContract.ownerOf(i);
            if (holder != address(0)) {
                entrants.add(holder);
            }
        }

        emit EntrantsUpdated(entrants.length());
    }
}
