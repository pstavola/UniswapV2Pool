# UniswapV2 Pool

Features

- Create a UniswapV2 Liquidity pool for a token pair
- Add first liquidity to the pool, earn liquidity token.
  > The first liquidity provider to join a pool sets the initial exchange rate by depositing what they believe to be an equivalent value of both tokens. If this ratio is off, arbitrage traders will bring the prices to equilibrium at the expense of the initial liquidity provider.
- Swap one token for another by any of the following methods:
  - swapSingleHopExactAmountIn (sells all tokens for another)
  - swapSingleHopExactAmountOut (buys specific amount of tokens set by the caller)
- Burn Liquidity tokens and remove liquidity you had provided.