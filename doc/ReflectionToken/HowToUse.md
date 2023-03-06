## Get started(Operation)

1. Deploy smart contract via Bunzz platform.  
Input UniswapV2Router address, token name and symbol as input params.
Once you deploy the smart contract, users can use the token like general ERC20 token.

2. Migrate old token.  
If you are already launched an ERC20 token and you want to upgrade the token to a reflection token, that is possible.
You just set the old token address as a migrate token address.

3. onlyOwner can conduct feature function calls.

## Additional features

### 1. Fee Tier
ContractOwner is able to configure the 5 types of fee percent taken from transaction; ecoSystemFee, liquidityFee, txFee, ownerFee, and burnFee.

- ecoSystemFee: for eco system or community. (owner can set the address).
- liquidityFee: for liquidity members.
- txFee: main fee which is deducted to accumulate reflection token.
- ownerFee: for contract owner. (he can set the owner address to get the fee). 
- burnFee: the fee which is burned on each tx. As default, burn fee is 0.

Please refer setEcoSystemFeePercent, setLiquidityFeePercent, setTaxFeePercent, setOwnerFeePercent, setBurnFeePercent, setEcoSystemFeeAddress, setOwnerFeeAddress and addTire functions

### 2. Non-staking addresses

Contract owner can add and remove some users in excludeReward list.
Please refer excludeFromReward and includeInReward functions.

### 3. blacklist, whitelist
Contract owner can add and remove some users in a blacklist using blacklistAddress and unBlacklistAddress functions.  
Contract owner can add and remove some users in a whitelist using whitelistAddress and excludeWhitelistedAddress functions.  
Please check the functions section to learn more specific functions.