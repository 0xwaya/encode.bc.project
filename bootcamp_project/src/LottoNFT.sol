// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin-contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";
import "openzeppelin-contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/utils/Strings.sol";

interface ILotto {
    function sendPrize() external returns (bytes32 requestId);
}

/// @title LottoNFT
/// @notice ERC721A tickets for the lottery. Every 5th mint triggers a draw.
contract LottoNFT is ERC721A, Ownable {
    uint256 public mintCost = 10 * 10 ** 18; // matches LottoCoin decimals if 18
    uint256 public constant MINT_AMOUNT = 1;
    uint256 public drawInterval = 5;

    string public baseTokenURI = "https://ipfs.io/ipfs/QmYGgEFqTRkWvNZ6u7gfk9HDdh55bQAbYVyc16TF1zX658/";

    IERC20 public coin;
    ILotto public lotto;

    event Minted(address indexed minter, uint256 tokenId);
    event DrawTriggered(uint256 totalSupply);

    constructor() ERC721A("LottoNFT", "LOTTO") {}

    function mint() external {
        require(address(coin) != address(0) && address(lotto) != address(0), "Not wired");
        require(coin.allowance(msg.sender, address(this)) >= mintCost, "Insufficient allowance");
        require(coin.balanceOf(msg.sender) >= mintCost, "Insufficient balance");

        require(coin.transferFrom(msg.sender, address(lotto), mintCost), "Payment failed");

        uint256 startId = totalSupply();
        _mint(msg.sender, MINT_AMOUNT);

        emit Minted(msg.sender, startId);

        if (totalSupply() % drawInterval == 0) {
            lotto.sendPrize();
            emit DrawTriggered(totalSupply());
        }
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Nonexistent token");
        return string(abi.encodePacked(baseTokenURI, Strings.toString(tokenId), ".json"));
    }

    function setCoinAddr(address _coin) external onlyOwner {
        require(_coin != address(0), "Zero address");
        coin = IERC20(_coin);
    }

    function setLottoAddr(address _lotto) external onlyOwner {
        require(_lotto != address(0), "Zero address");
        lotto = ILotto(_lotto);
    }

    function setMintCost(uint256 _cost) external onlyOwner {
        mintCost = _cost;
    }

    function setDrawInterval(uint256 _interval) external onlyOwner {
        require(_interval > 0, "Invalid interval");
        drawInterval = _interval;
    }

    function setBaseURI(string calldata _uri) external onlyOwner {
        baseTokenURI = _uri;
    }
}
