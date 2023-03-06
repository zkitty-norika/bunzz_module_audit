## Get started(Operation)

1. Deploy smart contract via Bunzz platform.  
Input UniswapV2Router address, token name and symbol as input params.
Once you deploy the smart contract, users can use the token like general ERC20 token.

2. Migrate old token.  
If you are already launched an ERC20 token and you want to upgrade the token to a reflection token, that is possible.
You just set the old token address as a migrate token address.

3. Other onlyOwner features.  
Contract owner can add and update fee tiers.
Please refer setEcoSystemFeePercent, setLiquidityFeePercent, setTaxFeePercent, setOwnerFeePercent, setBurnFeePercent, setEcoSystemFeeAddress, setOwnerFeeAddress and addTire functions

### Additional features

1. Contract owner can add and remove some users in excludeReward list.
Please refer excludeFromReward and includeInReward functions.

2. Contract owner can exclude or include some users from reward using excludeFromReward and includeReward functions.
Contract owner can add and remove some users in a blacklist using blacklistAddress and unBlacklistAddress functions.
Contract owner can add and remove some users in a whitelist using whitelistAddress and excludeWhitelistedAddress functions.
Please check the functions section to learn more specific functions.