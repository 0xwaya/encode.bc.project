# Setup & Wiring

## Prerequisites

- Node.js 16+
- Foundry (`foundryup`)
- Goerli ETH + LINK (or switch network)

## Install

```bash
npm install
cd bootcamp_project && forge install
```

## Deploy Order

1. **LottoCoin**
2. **Lotto** (fund with LINK after deploy)
3. **LottoNFT**

Then wire:

```solidity
lotto.setNftAddress(lottoNFTAddress);
lotto.setCoinAddress(lottoCoinAddress);
lottoNFT.setCoinAddr(lottoCoinAddress);
lottoNFT.setLottoAddr(lottoAddress);
```

Transfer some `LottoCoin` to the `Lotto` contract so it can pay prizes.

## Test

```bash
cd bootcamp_project
forge test -vv
```

## Notes

- VRF addresses in `Lotto.sol` are Goerli. Update for other networks.
- Mint cost = 10 LottoCoin. Prize = 10 LottoCoin. Every 5th mint triggers draw.
- `BootCampNFT.sol` is broken/non-compiling leftover — ignore or delete.
