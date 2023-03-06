## About
> one line description ← What issue does this module solve?

A ERC20 token module including auto-staking feature.

# Overview

## Goal

Reflection token has a built-in auto-staking feature, which is so-called DeFi 2.0 token. Users don't need to manually stake tokens into other contracts. Instead, users can safely store their tokens in their wallet while still earning rewards. This functionality provides investors with a source of passive income in a more secure way.

## What is Reflection token?

Reflection token will distribute fees to holders when a user makes a transaction. On the same time, a deflationary mechanism is built in to the token so that the balance of tokens one holds are worth more.


## Features
### Fee Tier
ContractOwner is able to configure the 5 types of fee percent taken from transaction; ecoSystemFee, liquidityFee, txFee, ownerFee, and burnFee.

- ecoSystemFee: ???
    - Q: When this fee is distributed to Whom?
- liquidityFee: ???
    - Q: When fee is distributed to Whom? 
- txFee: ???
    - Q: When fee is distributed to Whom? 
- ownerFee: ???
    - Q: When fee is distributed to Whom? 
- burnFee: ???
    - Q: When fee is distributed to Whom?
    - Q: Recommendation fee percent?

### t-space value and r-space value
`tTotal`, which belongs to t-space, represents tokens in circulation or total supply of a token. On the other hand, `rTotal`, which belongs to r-space, is a "reflected" value of tTotal, means token supply in reserve. values in t-space can easily be converted to r-space form, and vice versa using formula below.

Any t-space value $(t)$ can be converted to r-space value $(r)$ as follows:
$$ r = {tTotal \over rTotal} \cdot t $$


## Transaction
<a href="https://www.linkpicture.com/view.php?img=LPic61075f154e16f2017733822"><img src="https://www.linkpicture.com/q/Screen-Shot-2021-08-02-at-11.40.46.png" type="image"></a>

Note:  
(1) If sender is excluded from staking  
(2) If recipient is excluded from staking

Glossary:
- tAmount: token amount that sender pays/transfers including tFee
- tFee: transfer fee (note: 10% was chosen arbitrarily)
- tTransferAmount: tokens that will get transferred to recipient
- tOwned[user]: User’s balance represented in t-space (only used by non-stakers)
- rOwned[user]: User’s balance represented in r-space

### Define non-stakers

Router contracts, pair contracts, dev wallets are usually excluding from staking in order to fully reward users.

### White Paper

If you want to know the technical details, [This great technical paper](https://reflect-contract-doc.netlify.app/) is a good reference.