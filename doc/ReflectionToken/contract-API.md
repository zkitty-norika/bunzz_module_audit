# Contract API

## ReflectionToken

ERC20 token which has reflection system internally.  
The main concept of reflection system is proposed.  
Great articles are following:  
- [Mechanism from hackernoon](https://hackernoon.com/reflection-mechanism-and-crypto-a-deep-dive)

### FeeTier

```solidity
struct FeeTier {
  uint256 ecoSystemFee;
  uint256 liquidityFee;
  uint256 taxFee;
  uint256 ownerFee;
  uint256 burnFee;
  address ecoSystem;
  address owner;
}
```

### FeeValues

```solidity
struct FeeValues {
  uint256 rAmount;
  uint256 rTransferAmount;
  uint256 rFee;
  uint256 tTransferAmount;
  uint256 tEchoSystem;
  uint256 tLiquidity;
  uint256 tFee;
  uint256 tOwner;
  uint256 tBurn;
}
```

### tFeeValues

```solidity
struct tFeeValues {
  uint256 tTransferAmount;
  uint256 tEchoSystem;
  uint256 tLiquidity;
  uint256 tFee;
  uint256 tOwner;
  uint256 tBurn;
}
```

### maxFee

```solidity
uint256 maxFee
```

### defaultFees

```solidity
struct ReflectionToken.FeeTier defaultFees
```

### uniswapV2Router

```solidity
contract IUniswapV2Router02 uniswapV2Router
```

### uniswapV2Pair

```solidity
address uniswapV2Pair
```

### WETH

```solidity
address WETH
```

### migration

```solidity
address migration
```

### burnAddress

```solidity
address burnAddress
```

### numTokensToCollectETH

```solidity
uint256 numTokensToCollectETH
```

### numOfETHToSwapAndEvolve

```solidity
uint256 numOfETHToSwapAndEvolve
```

### maxTxAmount

```solidity
uint256 maxTxAmount
```

### inSwapAndLiquify

```solidity
bool inSwapAndLiquify
```

### swapAndEvolveEnabled

```solidity
bool swapAndEvolveEnabled
```

### MinTokensBeforeSwapUpdated

```solidity
event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap)
```

### lockTheSwap

```solidity
modifier lockTheSwap()
```

### lockUpgrade

```solidity
modifier lockUpgrade()
```

### checkTierIndex

```solidity
modifier checkTierIndex(uint256 _index)
```

### preventBlacklisted

```solidity
modifier preventBlacklisted(address _account, string errorMsg)
```

### isRouter

```solidity
modifier isRouter(address _sender)
```

### SwapAndEvolveEnabledUpdated

```solidity
event SwapAndEvolveEnabledUpdated(bool enabled)
```

### SwapAndEvolve

```solidity
event SwapAndEvolve(uint256 ethSwapped, uint256 tokenReceived, uint256 ethIntoLiquidity)
```

### constructor

```solidity
constructor(address _router, string __name, string __symbol) public
```

This is one line dev tag.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _router | address | Uniswap V2 router address |
| __name | string | the name of token |
| __symbol | string | the symbol of token |

### name

```solidity
function name() public view returns (string)
```

IERC20 functions

### symbol

```solidity
function symbol() public view returns (string)
```

### decimals

```solidity
function decimals() public view returns (uint8)
```

### totalSupply

```solidity
function totalSupply() public view returns (uint256)
```

Returns the amount of tokens in existence.

### balanceOf

```solidity
function balanceOf(address account) public view returns (uint256)
```

Returns the amount of tokens owned by `account`.

### transfer

```solidity
function transfer(address recipient, uint256 amount) public returns (bool)
```

Moves `amount` tokens from the caller's account to `recipient`.

Returns a boolean value indicating whether the operation succeeded.

Emits a {Transfer} event.

### allowance

```solidity
function allowance(address owner, address spender) public view returns (uint256)
```

Returns the remaining number of tokens that `spender` will be
allowed to spend on behalf of `owner` through {transferFrom}. This is
zero by default.

This value changes when {approve} or {transferFrom} are called.

### approve

```solidity
function approve(address spender, uint256 amount) public returns (bool)
```

Sets `amount` as the allowance of `spender` over the caller's tokens.

Returns a boolean value indicating whether the operation succeeded.

IMPORTANT: Beware that changing an allowance with this method brings the risk
that someone may use both the old and the new allowance by unfortunate
transaction ordering. One possible solution to mitigate this race
condition is to first reduce the spender's allowance to 0 and set the
desired value afterwards:
https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

Emits an {Approval} event.

### transferFrom

```solidity
function transferFrom(address sender, address recipient, uint256 amount) public returns (bool)
```

Moves `amount` tokens from `sender` to `recipient` using the
allowance mechanism. `amount` is then deducted from the caller's
allowance.

Returns a boolean value indicating whether the operation succeeded.

Emits a {Transfer} event.

### increaseAllowance

```solidity
function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool)
```

### decreaseAllowance

```solidity
function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool)
```

### migrate

```solidity
function migrate(address account, uint256 amount) external
```

Reflection functions

### excludeFromReward

```solidity
function excludeFromReward(address account) external
```

onlyOwner configuration functions

### includeInReward

```solidity
function includeInReward(address account) external
```

### excludeFromFee

```solidity
function excludeFromFee(address account) public
```

### includeInFee

```solidity
function includeInFee(address account) public
```

### whitelistAddress

```solidity
function whitelistAddress(address _account, uint256 _tierIndex) public
```

### excludeWhitelistedAddress

```solidity
function excludeWhitelistedAddress(address _account) public
```

### blacklistAddress

```solidity
function blacklistAddress(address account) public
```

### unBlacklistAddress

```solidity
function unBlacklistAddress(address account) public
```

### setEcoSystemFeePercent

```solidity
function setEcoSystemFeePercent(uint256 _tierIndex, uint256 _ecoSystemFee) external
```

Setter functions for fee configurations

### setLiquidityFeePercent

```solidity
function setLiquidityFeePercent(uint256 _tierIndex, uint256 _liquidityFee) external
```

### setTaxFeePercent

```solidity
function setTaxFeePercent(uint256 _tierIndex, uint256 _taxFee) external
```

### setOwnerFeePercent

```solidity
function setOwnerFeePercent(uint256 _tierIndex, uint256 _ownerFee) external
```

### setBurnFeePercent

```solidity
function setBurnFeePercent(uint256 _tierIndex, uint256 _burnFee) external
```

### setEcoSystemFeeAddress

```solidity
function setEcoSystemFeeAddress(uint256 _tierIndex, address _ecoSystem) external
```

### setOwnerFeeAddress

```solidity
function setOwnerFeeAddress(uint256 _tierIndex, address _owner) external
```

### addTier

```solidity
function addTier(uint256 _ecoSystemFee, uint256 _liquidityFee, uint256 _taxFee, uint256 _ownerFee, uint256 _burnFee, address _ecoSystem, address _owner) public
```

addTier is used for configuration of fee Tier.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _ecoSystemFee | uint256 | TBD |
| _liquidityFee | uint256 | TBD |
| _taxFee | uint256 | TBD |
| _ownerFee | uint256 | TBD |
| _burnFee | uint256 | TBD |
| _ecoSystem | address | TBD |
| _owner | address | TBD |

### setMaxTxPercent

```solidity
function setMaxTxPercent(uint256 maxTxPercent) external
```

Setter functions related to Uniswap

### setDefaultSettings

```solidity
function setDefaultSettings() external
```

### setSwapAndEvolveEnabled

```solidity
function setSwapAndEvolveEnabled(bool _enabled) public
```

### updateRouterAndPair

```solidity
function updateRouterAndPair(address _uniswapV2Router, address _uniswapV2Pair) public
```

### swapAndEvolve

```solidity
function swapAndEvolve() public
```

### setMigrationAddress

```solidity
function setMigrationAddress(address _migration) public
```

Set functions of addresses and the number of tokens

### updateBurnAddress

```solidity
function updateBurnAddress(address _newBurnAddress) external
```

### setNumberOfTokenToCollectETH

```solidity
function setNumberOfTokenToCollectETH(uint256 _numToken) public
```

### setNumOfETHToSwapAndEvolve

```solidity
function setNumOfETHToSwapAndEvolve(uint256 _numETH) public
```

### withdrawToken

```solidity
function withdrawToken(address _token, uint256 _amount) public
```

Withdraw functions

### withdrawETH

```solidity
function withdrawETH(uint256 _amount) public
```

### _addTier

```solidity
function _addTier(uint256 _ecoSystemFee, uint256 _liquidityFee, uint256 _taxFee, uint256 _ownerFee, uint256 _burnFee, address _ecoSystem, address _owner) internal returns (struct ReflectionToken.FeeTier)
```

Iternal/Private functions

### isExcludedFromReward

```solidity
function isExcludedFromReward(address account) public view returns (bool)
```

### reflectionFromTokenInTiers

```solidity
function reflectionFromTokenInTiers(uint256 tAmount, uint256 _tierIndex, bool deductTransferFee) public view returns (uint256)
```

### reflectionFromToken

```solidity
function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256)
```

### tokenFromReflection

```solidity
function tokenFromReflection(uint256 rAmount) public view returns (uint256)
```

### totalFees

```solidity
function totalFees() public view returns (uint256)
```

### accountTier

```solidity
function accountTier(address _account) public view returns (struct ReflectionToken.FeeTier)
```

### feeTier

```solidity
function feeTier(uint256 _tierIndex) public view returns (struct ReflectionToken.FeeTier)
```

### feeTiersLength

```solidity
function feeTiersLength() public view returns (uint256)
```

### isExcludedFromFee

```solidity
function isExcludedFromFee(address account) public view returns (bool)
```

### isWhitelisted

```solidity
function isWhitelisted(address _account) public view returns (bool)
```

### isBlacklisted

```solidity
function isBlacklisted(address account) public view returns (bool)
```

### isMigrationStarted

```solidity
function isMigrationStarted() external view returns (bool)
```

### getContractBalance

```solidity
function getContractBalance() public view returns (uint256)
```

### getETHBalance

```solidity
function getETHBalance() public view returns (uint256)
```

### _checkFees

```solidity
function _checkFees(struct ReflectionToken.FeeTier _tier) internal view returns (struct ReflectionToken.FeeTier)
```

### _checkFeesChanged

```solidity
function _checkFeesChanged(struct ReflectionToken.FeeTier _tier, uint256 _oldFee, uint256 _newFee) internal view
```

### receive

```solidity
receive() external payable
```

## IReflectionToken

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

Returns the amount of tokens in existence.

### balanceOf

```solidity
function balanceOf(address account) external view returns (uint256)
```

Returns the amount of tokens owned by `account`.

### transfer

```solidity
function transfer(address recipient, uint256 amount) external returns (bool)
```

Moves `amount` tokens from the caller's account to `recipient`.

Returns a boolean value indicating whether the operation succeeded.

Emits a {Transfer} event.

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

Returns the remaining number of tokens that `spender` will be
allowed to spend on behalf of `owner` through {transferFrom}. This is
zero by default.

This value changes when {approve} or {transferFrom} are called.

### approve

```solidity
function approve(address spender, uint256 amount) external returns (bool)
```

Sets `amount` as the allowance of `spender` over the caller's tokens.

Returns a boolean value indicating whether the operation succeeded.

IMPORTANT: Beware that changing an allowance with this method brings the risk
that someone may use both the old and the new allowance by unfortunate
transaction ordering. One possible solution to mitigate this race
condition is to first reduce the spender's allowance to 0 and set the
desired value afterwards:
https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

Emits an {Approval} event.

### transferFrom

```solidity
function transferFrom(address sender, address recipient, uint256 amount) external returns (bool)
```

Moves `amount` tokens from `sender` to `recipient` using the
allowance mechanism. `amount` is then deducted from the caller's
allowance.

Returns a boolean value indicating whether the operation succeeded.

Emits a {Transfer} event.

### migrate

```solidity
function migrate(address account, uint256 amount) external
```

Creates `amount` tokens and assigns them to `account`, increasing
the total supply.

Emits a {Transfer} event with `from` set to the zero address.

Requirements:

- `account` cannot be the zero address.

### isMigrationStarted

```solidity
function isMigrationStarted() external view returns (bool)
```

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

Emitted when `value` tokens are moved from one account (`from`) to
another (`to`).

Note that `value` may be zero.

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

Emitted when the allowance of a `spender` for an `owner` is set by
a call to {approve}. `value` is the new allowance.

## IUniswapV2Factory

### PairCreated

```solidity
event PairCreated(address token0, address token1, address pair, uint256)
```

### feeTo

```solidity
function feeTo() external view returns (address)
```

### feeToSetter

```solidity
function feeToSetter() external view returns (address)
```

### getPair

```solidity
function getPair(address tokenA, address tokenB) external view returns (address pair)
```

### allPairs

```solidity
function allPairs(uint256) external view returns (address pair)
```

### allPairsLength

```solidity
function allPairsLength() external view returns (uint256)
```

### createPair

```solidity
function createPair(address tokenA, address tokenB) external returns (address pair)
```

### setFeeTo

```solidity
function setFeeTo(address) external
```

### setFeeToSetter

```solidity
function setFeeToSetter(address) external
```

## IUniswapV2Pair

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

### name

```solidity
function name() external pure returns (string)
```

### symbol

```solidity
function symbol() external pure returns (string)
```

### decimals

```solidity
function decimals() external pure returns (uint8)
```

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

### balanceOf

```solidity
function balanceOf(address owner) external view returns (uint256)
```

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

### approve

```solidity
function approve(address spender, uint256 value) external returns (bool)
```

### transfer

```solidity
function transfer(address to, uint256 value) external returns (bool)
```

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 value) external returns (bool)
```

### DOMAIN_SEPARATOR

```solidity
function DOMAIN_SEPARATOR() external view returns (bytes32)
```

### PERMIT_TYPEHASH

```solidity
function PERMIT_TYPEHASH() external pure returns (bytes32)
```

### nonces

```solidity
function nonces(address owner) external view returns (uint256)
```

### permit

```solidity
function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external
```

### Mint

```solidity
event Mint(address sender, uint256 amount0, uint256 amount1)
```

### Burn

```solidity
event Burn(address sender, uint256 amount0, uint256 amount1, address to)
```

### Swap

```solidity
event Swap(address sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address to)
```

### Sync

```solidity
event Sync(uint112 reserve0, uint112 reserve1)
```

### MINIMUM_LIQUIDITY

```solidity
function MINIMUM_LIQUIDITY() external pure returns (uint256)
```

### factory

```solidity
function factory() external view returns (address)
```

### token0

```solidity
function token0() external view returns (address)
```

### token1

```solidity
function token1() external view returns (address)
```

### getReserves

```solidity
function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast)
```

### price0CumulativeLast

```solidity
function price0CumulativeLast() external view returns (uint256)
```

### price1CumulativeLast

```solidity
function price1CumulativeLast() external view returns (uint256)
```

### kLast

```solidity
function kLast() external view returns (uint256)
```

### mint

```solidity
function mint(address to) external returns (uint256 liquidity)
```

### burn

```solidity
function burn(address to) external returns (uint256 amount0, uint256 amount1)
```

### swap

```solidity
function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes data) external
```

### skim

```solidity
function skim(address to) external
```

### sync

```solidity
function sync() external
```

### initialize

```solidity
function initialize(address, address) external
```

## IUniswapV2Router01

### factory

```solidity
function factory() external pure returns (address)
```

### WETH

```solidity
function WETH() external pure returns (address)
```

### addLiquidity

```solidity
function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB, uint256 liquidity)
```

### addLiquidityETH

```solidity
function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity)
```

### removeLiquidity

```solidity
function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB)
```

### removeLiquidityETH

```solidity
function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountToken, uint256 amountETH)
```

### removeLiquidityWithPermit

```solidity
function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountA, uint256 amountB)
```

### removeLiquidityETHWithPermit

```solidity
function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountToken, uint256 amountETH)
```

### swapExactTokensForTokens

```solidity
function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapTokensForExactTokens

```solidity
function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapExactETHForTokens

```solidity
function swapExactETHForTokens(uint256 amountOutMin, address[] path, address to, uint256 deadline) external payable returns (uint256[] amounts)
```

### swapTokensForExactETH

```solidity
function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapExactTokensForETH

```solidity
function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapETHForExactTokens

```solidity
function swapETHForExactTokens(uint256 amountOut, address[] path, address to, uint256 deadline) external payable returns (uint256[] amounts)
```

### quote

```solidity
function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB)
```

### getAmountOut

```solidity
function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountOut)
```

### getAmountIn

```solidity
function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountIn)
```

### getAmountsOut

```solidity
function getAmountsOut(uint256 amountIn, address[] path) external view returns (uint256[] amounts)
```

### getAmountsIn

```solidity
function getAmountsIn(uint256 amountOut, address[] path) external view returns (uint256[] amounts)
```

## IUniswapV2Router02

### removeLiquidityETHSupportingFeeOnTransferTokens

```solidity
function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountETH)
```

### removeLiquidityETHWithPermitSupportingFeeOnTransferTokens

```solidity
function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH)
```

### swapExactTokensForTokensSupportingFeeOnTransferTokens

```solidity
function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external
```

### swapExactETHForTokensSupportingFeeOnTransferTokens

```solidity
function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] path, address to, uint256 deadline) external payable
```

### swapExactTokensForETHSupportingFeeOnTransferTokens

```solidity
function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external
```

