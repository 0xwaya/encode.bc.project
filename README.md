# ETHDenver Bootcamp Lottery NFT

ETHDenver 2022 Bootcamp Group 8 final project — a simple on-chain lottery where minting NFTs with a custom ERC20 enters holders into a periodic draw. Chainlink VRF selects the winner.

**Team:** @kylemilden237 · @JohnGkliatis · @0xwaya

## Concept

1. Deploy `LottoCoin` (ERC20) and distribute tokens.
2. Deploy `Lotto` (VRF consumer) and fund it with LINK.
3. Deploy `LottoNFT`. Users approve + pay `LottoCoin` to mint.
4. Every 5th mint triggers `Lotto.sendPrize()` → VRF → random holder receives prize tokens.

## Contracts

| Contract     | Purpose                          |
|--------------|----------------------------------|
| `LottoCoin`  | ERC20 payment + prize token      |
| `LottoNFT`   | ERC721A mintable lottery tickets |
| `Lotto`      | VRF lottery logic + prize payout |

## Quick Start

```bash
# Hardhat (deployment)
npm install
npx hardhat compile
npx hardhat run deploy/deploy.js --network goerli

# Foundry (tests)
cd bootcamp_project
forge install
forge test
```

See [docs/SETUP.md](docs/SETUP.md) for full steps and [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for design notes.

## Status

Educational / historical project. Contracts have been cleaned and documented. VRF addresses are Goerli-era; update for modern networks before any real use.

## License

MIT
