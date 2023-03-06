# ReflectionToken contract description table

|  File Name  |  SHA-1 Hash  |
|-------------|--------------|
| /Users/norika/Project/bunzz/code-review-modules/bunzz_module_audit/contracts/ReflectionToken/ReflectionToken.sol | 65120a3fb507f2e8f5d7e02a8a9ff02063bb77fd |
| /Users/norika/Project/bunzz/code-review-modules/bunzz_module_audit/contracts/ReflectionToken/interface/IReflectionToken.sol | 1408b70384c41532aac218314072f519ac5c4c03 |
| /Users/norika/Project/bunzz/code-review-modules/bunzz_module_audit/contracts/ReflectionToken/interface/IUniswapV2Factory.sol | 5abadd59234e19e8101f347117e10ecf99be5e96 |
| /Users/norika/Project/bunzz/code-review-modules/bunzz_module_audit/contracts/ReflectionToken/interface/IUniswapV2Pair.sol | d8e073b231ec7a874842af4f36817320fd6667d4 |
| /Users/norika/Project/bunzz/code-review-modules/bunzz_module_audit/contracts/ReflectionToken/interface/IUniswapV2Router02.sol | e487fdd51c4ac07c2844bd254f05affb46088dcf |
| /Users/norika/Project/bunzz/code-review-modules/bunzz_module_audit/contracts/ReflectionToken/interface/IUniswapV2Router01.sol | 01145b910fce31a31c0ec4965380a4b98ecd22ce |
| /Users/norika/Project/bunzz/code-review-modules/bunzz_module_audit/node_modules/@openzeppelin/contracts/access/Ownable.sol | 691ac8cc8ecc93fa144beb50c3b0263300d15321 |
| /Users/norika/Project/bunzz/code-review-modules/bunzz_module_audit/node_modules/@openzeppelin/contracts/utils/Context.sol | 719844505df30bda93516e78eab1ced3bfe9ff4a |
| /Users/norika/Project/bunzz/code-review-modules/bunzz_module_audit/node_modules/@openzeppelin/contracts/utils/Address.sol | 169faebd8dc11ce16251c6075421d8f9fa126c58 |


 Contracts Description Table


|  Contract  |         Type        |       Bases      |                  |                 |
|:----------:|:-------------------:|:----------------:|:----------------:|:---------------:|
|     └      |  **Function Name**  |  **Visibility**  |  **Mutability**  |  **Modifiers**  |
||||||
| **ReflectionToken** | Implementation | IReflectionToken, Ownable |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | name | Public ❗️ |   |NO❗️ |
| └ | symbol | Public ❗️ |   |NO❗️ |
| └ | decimals | Public ❗️ |   |NO❗️ |
| └ | totalSupply | Public ❗️ |   |NO❗️ |
| └ | balanceOf | Public ❗️ |   |NO❗️ |
| └ | transfer | Public ❗️ | 🛑  |NO❗️ |
| └ | allowance | Public ❗️ |   |NO❗️ |
| └ | approve | Public ❗️ | 🛑  |NO❗️ |
| └ | transferFrom | Public ❗️ | 🛑  |NO❗️ |
| └ | increaseAllowance | Public ❗️ | 🛑  |NO❗️ |
| └ | decreaseAllowance | Public ❗️ | 🛑  |NO❗️ |
| └ | migrate | External ❗️ | 🛑  | preventBlacklisted |
| └ | excludeFromReward | External ❗️ | 🛑  | onlyOwner |
| └ | _excludeFromReward | Private 🔐 | 🛑  | |
| └ | includeInReward | External ❗️ | 🛑  | onlyOwner |
| └ | excludeFromFee | Public ❗️ | 🛑  | onlyOwner |
| └ | includeInFee | Public ❗️ | 🛑  | onlyOwner |
| └ | whitelistAddress | Public ❗️ | 🛑  | onlyOwner checkTierIndex preventBlacklisted |
| └ | excludeWhitelistedAddress | Public ❗️ | 🛑  | onlyOwner |
| └ | blacklistAddress | Public ❗️ | 🛑  | onlyOwner |
| └ | unBlacklistAddress | Public ❗️ | 🛑  | onlyOwner |
| └ | setEcoSystemFeePercent | External ❗️ | 🛑  | onlyOwner checkTierIndex |
| └ | setLiquidityFeePercent | External ❗️ | 🛑  | onlyOwner checkTierIndex |
| └ | setTaxFeePercent | External ❗️ | 🛑  | onlyOwner checkTierIndex |
| └ | setOwnerFeePercent | External ❗️ | 🛑  | onlyOwner checkTierIndex |
| └ | setBurnFeePercent | External ❗️ | 🛑  | onlyOwner checkTierIndex |
| └ | setEcoSystemFeeAddress | External ❗️ | 🛑  | onlyOwner checkTierIndex |
| └ | setOwnerFeeAddress | External ❗️ | 🛑  | onlyOwner checkTierIndex |
| └ | addTier | Public ❗️ | 🛑  | onlyOwner |
| └ | setMaxTxPercent | External ❗️ | 🛑  | onlyOwner |
| └ | setDefaultSettings | External ❗️ | 🛑  | onlyOwner |
| └ | setSwapAndEvolveEnabled | Public ❗️ | 🛑  | onlyOwner |
| └ | updateRouterAndPair | Public ❗️ | 🛑  | onlyOwner |
| └ | swapAndEvolve | Public ❗️ | 🛑  | onlyOwner lockTheSwap |
| └ | setMigrationAddress | Public ❗️ | 🛑  | onlyOwner |
| └ | updateBurnAddress | External ❗️ | 🛑  | onlyOwner |
| └ | setNumberOfTokenToCollectETH | Public ❗️ | 🛑  | onlyOwner |
| └ | setNumOfETHToSwapAndEvolve | Public ❗️ | 🛑  | onlyOwner |
| └ | withdrawToken | Public ❗️ | 🛑  | onlyOwner |
| └ | withdrawETH | Public ❗️ | 🛑  | onlyOwner |
| └ | _addTier | Internal 🔒 | 🛑  | |
| └ | _reflectFee | Private 🔐 | 🛑  | |
| └ | _removeAllFee | Private 🔐 | 🛑  | |
| └ | _restoreAllFee | Private 🔐 | 🛑  | |
| └ | _approve | Private 🔐 | 🛑  | preventBlacklisted preventBlacklisted |
| └ | _transfer | Private 🔐 | 🛑  | preventBlacklisted preventBlacklisted preventBlacklisted isRouter |
| └ | _collectETH | Private 🔐 | 🛑  | lockTheSwap |
| └ | _swapTokensForETH | Private 🔐 | 🛑  | |
| └ | _swapETHForTokens | Private 🔐 | 🛑  | |
| └ | _addLiquidity | Private 🔐 | 🛑  | |
| └ | _tokenTransfer | Private 🔐 | 🛑  | |
| └ | _transferBothExcluded | Private 🔐 | 🛑  | |
| └ | _transferStandard | Private 🔐 | 🛑  | |
| └ | _transferToExcluded | Private 🔐 | 🛑  | |
| └ | _transferFromExcluded | Private 🔐 | 🛑  | |
| └ | _takeFees | Private 🔐 | 🛑  | |
| └ | _takeFee | Private 🔐 | 🛑  | |
| └ | _takeBurn | Private 🔐 | 🛑  | |
| └ | _migrate | Private 🔐 | 🛑  | |
| └ | isExcludedFromReward | Public ❗️ |   |NO❗️ |
| └ | reflectionFromTokenInTiers | Public ❗️ |   |NO❗️ |
| └ | reflectionFromToken | Public ❗️ |   |NO❗️ |
| └ | tokenFromReflection | Public ❗️ |   |NO❗️ |
| └ | totalFees | Public ❗️ |   |NO❗️ |
| └ | accountTier | Public ❗️ |   |NO❗️ |
| └ | feeTier | Public ❗️ |   | checkTierIndex |
| └ | feeTiersLength | Public ❗️ |   |NO❗️ |
| └ | isExcludedFromFee | Public ❗️ |   |NO❗️ |
| └ | isWhitelisted | Public ❗️ |   |NO❗️ |
| └ | isBlacklisted | Public ❗️ |   |NO❗️ |
| └ | isMigrationStarted | External ❗️ |   |NO❗️ |
| └ | getContractBalance | Public ❗️ |   |NO❗️ |
| └ | getETHBalance | Public ❗️ |   |NO❗️ |
| └ | _getRate | Private 🔐 |   | |
| └ | _getCurrentSupply | Private 🔐 |   | |
| └ | _calculateFee | Private 🔐 |   | |
| └ | _getRValues | Private 🔐 |   | |
| └ | _getValues | Private 🔐 |   | |
| └ | _getTValues | Private 🔐 |   | |
| └ | _checkFees | Internal 🔒 |   | |
| └ | _checkFeesChanged | Internal 🔒 |   | |
| └ | <Receive Ether> | External ❗️ |  💵 |NO❗️ |
||||||
| **IReflectionToken** | Interface |  |||
| └ | totalSupply | External ❗️ |   |NO❗️ |
| └ | balanceOf | External ❗️ |   |NO❗️ |
| └ | transfer | External ❗️ | 🛑  |NO❗️ |
| └ | allowance | External ❗️ |   |NO❗️ |
| └ | approve | External ❗️ | 🛑  |NO❗️ |
| └ | transferFrom | External ❗️ | 🛑  |NO❗️ |
| └ | migrate | External ❗️ | 🛑  |NO❗️ |
| └ | isMigrationStarted | External ❗️ |   |NO❗️ |
||||||
| **IUniswapV2Factory** | Interface |  |||
| └ | feeTo | External ❗️ |   |NO❗️ |
| └ | feeToSetter | External ❗️ |   |NO❗️ |
| └ | getPair | External ❗️ |   |NO❗️ |
| └ | allPairs | External ❗️ |   |NO❗️ |
| └ | allPairsLength | External ❗️ |   |NO❗️ |
| └ | createPair | External ❗️ | 🛑  |NO❗️ |
| └ | setFeeTo | External ❗️ | 🛑  |NO❗️ |
| └ | setFeeToSetter | External ❗️ | 🛑  |NO❗️ |
||||||
| **IUniswapV2Pair** | Interface |  |||
| └ | name | External ❗️ |   |NO❗️ |
| └ | symbol | External ❗️ |   |NO❗️ |
| └ | decimals | External ❗️ |   |NO❗️ |
| └ | totalSupply | External ❗️ |   |NO❗️ |
| └ | balanceOf | External ❗️ |   |NO❗️ |
| └ | allowance | External ❗️ |   |NO❗️ |
| └ | approve | External ❗️ | 🛑  |NO❗️ |
| └ | transfer | External ❗️ | 🛑  |NO❗️ |
| └ | transferFrom | External ❗️ | 🛑  |NO❗️ |
| └ | DOMAIN_SEPARATOR | External ❗️ |   |NO❗️ |
| └ | PERMIT_TYPEHASH | External ❗️ |   |NO❗️ |
| └ | nonces | External ❗️ |   |NO❗️ |
| └ | permit | External ❗️ | 🛑  |NO❗️ |
| └ | MINIMUM_LIQUIDITY | External ❗️ |   |NO❗️ |
| └ | factory | External ❗️ |   |NO❗️ |
| └ | token0 | External ❗️ |   |NO❗️ |
| └ | token1 | External ❗️ |   |NO❗️ |
| └ | getReserves | External ❗️ |   |NO❗️ |
| └ | price0CumulativeLast | External ❗️ |   |NO❗️ |
| └ | price1CumulativeLast | External ❗️ |   |NO❗️ |
| └ | kLast | External ❗️ |   |NO❗️ |
| └ | mint | External ❗️ | 🛑  |NO❗️ |
| └ | burn | External ❗️ | 🛑  |NO❗️ |
| └ | swap | External ❗️ | 🛑  |NO❗️ |
| └ | skim | External ❗️ | 🛑  |NO❗️ |
| └ | sync | External ❗️ | 🛑  |NO❗️ |
| └ | initialize | External ❗️ | 🛑  |NO❗️ |
||||||
| **IUniswapV2Router02** | Interface | IUniswapV2Router01 |||
| └ | removeLiquidityETHSupportingFeeOnTransferTokens | External ❗️ | 🛑  |NO❗️ |
| └ | removeLiquidityETHWithPermitSupportingFeeOnTransferTokens | External ❗️ | 🛑  |NO❗️ |
| └ | swapExactTokensForTokensSupportingFeeOnTransferTokens | External ❗️ | 🛑  |NO❗️ |
| └ | swapExactETHForTokensSupportingFeeOnTransferTokens | External ❗️ |  💵 |NO❗️ |
| └ | swapExactTokensForETHSupportingFeeOnTransferTokens | External ❗️ | 🛑  |NO❗️ |
||||||
| **IUniswapV2Router01** | Interface |  |||
| └ | factory | External ❗️ |   |NO❗️ |
| └ | WETH | External ❗️ |   |NO❗️ |
| └ | addLiquidity | External ❗️ | 🛑  |NO❗️ |
| └ | addLiquidityETH | External ❗️ |  💵 |NO❗️ |
| └ | removeLiquidity | External ❗️ | 🛑  |NO❗️ |
| └ | removeLiquidityETH | External ❗️ | 🛑  |NO❗️ |
| └ | removeLiquidityWithPermit | External ❗️ | 🛑  |NO❗️ |
| └ | removeLiquidityETHWithPermit | External ❗️ | 🛑  |NO❗️ |
| └ | swapExactTokensForTokens | External ❗️ | 🛑  |NO❗️ |
| └ | swapTokensForExactTokens | External ❗️ | 🛑  |NO❗️ |
| └ | swapExactETHForTokens | External ❗️ |  💵 |NO❗️ |
| └ | swapTokensForExactETH | External ❗️ | 🛑  |NO❗️ |
| └ | swapExactTokensForETH | External ❗️ | 🛑  |NO❗️ |
| └ | swapETHForExactTokens | External ❗️ |  💵 |NO❗️ |
| └ | quote | External ❗️ |   |NO❗️ |
| └ | getAmountOut | External ❗️ |   |NO❗️ |
| └ | getAmountIn | External ❗️ |   |NO❗️ |
| └ | getAmountsOut | External ❗️ |   |NO❗️ |
| └ | getAmountsIn | External ❗️ |   |NO❗️ |
||||||
| **Ownable** | Implementation | Context |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | owner | Public ❗️ |   |NO❗️ |
| └ | _checkOwner | Internal 🔒 |   | |
| └ | renounceOwnership | Public ❗️ | 🛑  | onlyOwner |
| └ | transferOwnership | Public ❗️ | 🛑  | onlyOwner |
| └ | _transferOwnership | Internal 🔒 | 🛑  | |
||||||
| **Context** | Implementation |  |||
| └ | _msgSender | Internal 🔒 |   | |
| └ | _msgData | Internal 🔒 |   | |
||||||
| **Address** | Library |  |||
| └ | isContract | Internal 🔒 |   | |
| └ | sendValue | Internal 🔒 | 🛑  | |
| └ | functionCall | Internal 🔒 | 🛑  | |
| └ | functionCall | Internal 🔒 | 🛑  | |
| └ | functionCallWithValue | Internal 🔒 | 🛑  | |
| └ | functionCallWithValue | Internal 🔒 | 🛑  | |
| └ | functionStaticCall | Internal 🔒 |   | |
| └ | functionStaticCall | Internal 🔒 |   | |
| └ | functionDelegateCall | Internal 🔒 | 🛑  | |
| └ | functionDelegateCall | Internal 🔒 | 🛑  | |
| └ | verifyCallResultFromTarget | Internal 🔒 |   | |
| └ | verifyCallResult | Internal 🔒 |   | |
| └ | _revert | Private 🔐 |   | |


 Legend

|  Symbol  |  Meaning  |
|:--------:|-----------|
|    🛑    | Function can modify state |
|    💵    | Function is payable |

## Credit
Sūrya's Description Report
