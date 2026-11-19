# Architecture

## Flow

```
User → approve LottoCoin → LottoNFT.mint()
         ↓
    transferFrom to Lotto contract
         ↓
    if totalSupply % 5 == 0 → Lotto.sendPrize()
         ↓
    Chainlink VRF → fulfillRandomness
         ↓
    rebuild entrants set from NFT holders
         ↓
    pick winner + transfer prize
```

## Key Design Decisions

- **ERC721A** for gas-efficient batch mints (single mint of 1 still benefits from the library).
- **EnumerableSet** to track unique NFT holders as entrants.
- **VRF v1** (VRFConsumerBase) — original bootcamp choice. Hard-coded Goerli coordinator/keyHash.
- Prize paid in `LottoCoin` from the Lotto contract balance.

## Known Limitations (original)

- Entrants set is rebuilt on every draw (gas-heavy for large supplies).
- No clear of previous entrants before rebuild → duplicates possible if tokens transfer.
- No events on critical actions.
- VRF v1 is deprecated; migrate to VRF v2.5 for production.
- Hard-coded costs and prize amounts.

## Improvements Applied

- Added events (`PrizeRequested`, `WinnerSelected`, `EntrantsUpdated`).
- Clear entrants set before rebuild.
- Zero-address and balance checks.
- Cleaner imports and comments.
- Documented wiring order.
