//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/IReflectionToken.sol";
import "./interface/IUniswapV2Factory.sol";
import "./interface/IUniswapV2Pair.sol";
import "./interface/IUniswapV2Router02.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title ReflectionToken
 * @dev ERC20 token which has reflection system internally.  
 * - On transfer funcion, the fee mount of the token is deducted from the amount tarnsferred, 
 * and added to 4 recipients; ecoSystem, UniswapV2liquidity, tax vault, owner
 * 
 * - 
 *  
 */
contract ReflectionToken is IReflectionToken, Ownable {
    // Review: 
    // - TODO: Should comment that fee vairables are the numerator in case the denominator is maxFee.
    struct FeeTier {
        uint256 ecoSystemFee;
        uint256 liquidityFee;
        uint256 taxFee;
        uint256 ownerFee;
        uint256 burnFee;
        address ecoSystem;
        address owner;
    }

    // Review: 
    // - Prefix r represents ReflectionReward?
    // - TODO: the struct name should be FeeAmounts, to clarify the variables are amount, not fee numerator.
    // - TODO: Shoud comment that FeeValues is the amount of token which is calculated by given tierAmount.
    // - TODO: add explaration for each variables

    struct FeeValues {
        // rAmount
        uint256 rAmount;
        uint256 rTransferAmount;
        uint256 rFee;
        // TODO: transferAmount? Do you mean amountTransferred?
        // TODO: => The name of tTransferAmount shoud be tTransfableAmount.
        uint256 tTransferAmount;
        // TODO: did you mean tEcoSystem?
        uint256 tEchoSystem;
        uint256 tLiquidity;
        uint256 tFee;
        uint256 tOwner;
        uint256 tBurn;
    }

    // Review: 
    // - TODO: Shoud mention the prefix "t" represents Tier.
    struct tFeeValues {
        uint256 tTransferAmount;
        //TODO: did you mean tEcoSystem?
        uint256 tEchoSystem;
        uint256 tLiquidity;
        uint256 tFee;
        uint256 tOwner;
        uint256 tBurn;
    }

    // Review: 
    // - TODO: Need a explanation of the relationship with _rBalance and _tBalance.
    // - TODO: how do you calculate the balance?
    /**
     * Balances: reflection token amout, and total amount
     */
    // DONE: changed to _rBalance. Add a clear definition.
    mapping(address => uint256) private _rBalance;
    // TODO(question): t means total? Add a clear definition.
    // DONE: changed to _tBalance
    mapping(address => uint256) private _tBalance;
    mapping(address => mapping(address => uint256)) private _allowances;

    /**
     * identifiers if the fee should be deducted or not when token transfer occurs.
     */
    // true if the fee should be deducted or not when token transfer occurs.
    mapping(address => bool) private _isExcludedFromFee;
    // DONE(bad naming): Should change to _isExcludedFromReward
    mapping(address => bool) private _isExcludedFromReward;
    mapping(address => bool) private _isBlacklisted;
    // get feeTierIndex by address
    mapping(address => uint256) private _accountsTier;

    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal;
    uint256 private _rTotal;
    uint256 private _tFeeTotal;
    // TODO: should mention that maxFee is the denominator of fee ratio.
    uint256 public maxFee;

    string private _name = "ReflectionToken";
    string private _symbol = "RFT";

    FeeTier public defaultFees;
    FeeTier private _previousFees;
    FeeTier private _emptyFees;

    FeeTier[] private _feeTiers;

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    address public WETH;
    address public migration;
    address public burnAddress;

    uint256 public numTokensToCollectETH;
    // DONE(Bad naming): numOfETHToSwapAndEvolve should be amountOfETHToSwapAndEvolve
    uint256 public amountOfETHToSwapAndEvolve;

    // Review: 
    // - TODO: what is maxTxAmount used for?
    uint256 public maxTxAmount;

    uint256 private _rTotalExcluded;
    uint256 private _tTotalExcluded;

    uint8 private _decimals;

    bool public inSwapAndLiquify;
    bool private _upgraded;

    bool public swapAndEvolveEnabled;

    event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);

    // Review: 
    // - TODO: ?????
    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    // Review: ?????
    modifier lockUpgrade() {
        require(!_upgraded, "ReflectionToken: Already upgraded");
        _;
        _upgraded = true;
    }

    modifier checkTierIndex(uint256 _index) {
        require(_feeTiers.length > _index, "ReflectionToken: Invalid tier index");
        _;
    }

    modifier preventBlacklisted(address _account, string memory errorMsg) {
        require(!_isBlacklisted[_account], errorMsg);
        _;
    }

    modifier isRouter(address _sender) {
        {
            uint32 size;
            assembly {
                size := extcodesize(_sender)
            }
            if (size > 0) {
                if (_accountsTier[_sender] == 0) {
                    IUniswapV2Router02 _routerCheck = IUniswapV2Router02(_sender);
                    try _routerCheck.factory() returns (address factory) {
                        _accountsTier[_sender] = 1;
                    } catch {}
                }
            }
        }

        _;
    }

    event SwapAndEvolveEnabledUpdated(bool enabled);
    event SwapAndEvolve(uint256 ethSwapped, uint256 tokenReceived, uint256 ethIntoLiquidity);

    // Review: Doing
    /**
     * @dev rBalance
     * @param _router Uniswap V2 router address
     * @param __name the name of token
     * @param __symbol the symbol of token
     */
    constructor(address _router, string memory __name, string memory __symbol) {
        _name = __name;
        _symbol = __symbol;
        _decimals = 9;

        // TODO: Why the amount of total supply is not configurable?
        uint tTotal = 1000000 * 10**6 * 10**9;
        // TODO: Potential reflection amount to mint without overflow?
        uint rTotal = (MAX - (MAX % tTotal));// MAX = ~uint256(0)

        _tTotal = tTotal;
        _rTotal = rTotal;

        // TODO: change to maxFeeDenominator, or
        // comment: fee denominator is 1000
        maxFee = 1000;

        maxTxAmount = 5000 * 10**6 * 10**9;

        burnAddress = 0x000000000000000000000000000000000000dEaD;

        address ownerAddress = owner();

        // Review: 
        // - TODO: why owner(= contract deployer) will own all refection token?
        // All potential reflection amount will be given to the token owner.
        _rBalance[ownerAddress] = rTotal;

        uniswapV2Router = IUniswapV2Router02(_router);
        WETH = uniswapV2Router.WETH();
        // Create a uniswap pair for this new token
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), WETH);

        // We won't take a fee from owner and this contract.
        _isExcludedFromFee[ownerAddress] = true;
        _isExcludedFromFee[address(this)] = true;

        // init _feeTiers

        // Review:
        // - TODO: Why are you adding 3 feeTiers?
        // - TODO: what Tier user should use for what use-case??

        // liquidityFee, taxFee
        defaultFees = _addTier(0, 500, 500, 0, 0, address(0), address(0));
        // ecoSystemFee, liquidityFee, taxFee
        _addTier(50, 50, 100, 0, 0, address(0), address(0));
        // ecoSystemFee, liquidityFee, taxFee, ownerFee
        _addTier(50, 50, 100, 100, 0, address(0), address(0));
        // ecoSystemFee, liquidityFee, taxFee, ownerFee
        _addTier(100, 125, 125, 150, 0, address(0), address(0));

        emit Transfer(address(0), msg.sender, tTotal);
    }

    // Review:
    // - TODO: Should inherit IERC20
    /**
     * IERC20 functions
     */

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    // Review: most important
    // TODO: why tOwned is not used?
    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcludedFromReward[account]) return _tBalance[account];
        return getTotalAmountFromReflection(_rBalance[account]);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender] - amount
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        require(_allowances[msg.sender][spender] >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender] - subtractedValue
        );
        return true;
    }

    /**
     * Reflection functions
     */

    // TODO: migrate what to whom?
    function migrate(address account, uint256 amount)
    external
    override
    preventBlacklisted(account, "ReflectionToken: Migrated account is blacklisted")
    {
        require(migration != address(0), "ReflectionToken: Migration is not started");
        require(msg.sender == migration, "ReflectionToken: Not Allowed");
        _migrate(account, amount);
    }

    // Review:
    // - TODO: Better to have the convention style
    /**
     * onlyOwner configuration functions
     */

    // Review: 
    // - TODO: exclude from what?
    // we update _rTotalExcluded and _tTotalExcluded when add, remove wallet from excluded list
    // or when increase, decrease exclude value
    function excludeFromReward(address account) external onlyOwner {
        require(!_isExcludedFromReward[account], "Account is already excluded");
        _excludeFromReward(account);
    }

    function _excludeFromReward(address account) private {
        if (_rBalance[account] > 0) {
            _tBalance[account] = getTotalAmountFromReflection(_rBalance[account]);
            _tTotalExcluded += _tBalance[account];
            _rTotalExcluded +=  _rBalance[account];
        }

        _isExcludedFromReward[account] = true;
    }

    // we update _rTotalExcluded and _tTotalExcluded when add, remove wallet from excluded list
    // or when increase, decrease exclude value
    function includeInReward(address account) external onlyOwner {
        require(_isExcludedFromReward[account], "Account is already included");
        // TODO: Input the gurad for subtraction
        // DONE: better to modify the coding style simply
        _tTotalExcluded -= _tBalance[account];
        _rTotalExcluded -=  _rBalance[account];
        _tBalance[account] = 0;
        _isExcludedFromReward[account] = false;
    }

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }

    // Review:
    // - TODO: Owner have to input the all WL addresses by calling this function?
    // - TODO: shoud consider to take the list of accounts as argument.
    function whitelistAddress(address _account, uint256 _tierIndex)
    public
    onlyOwner
    checkTierIndex(_tierIndex)
    preventBlacklisted(_account, "ReflectionToken: Selected account is in blacklist")
    {
        require(_account != address(0), "ReflectionToken: Invalid address");
        _accountsTier[_account] = _tierIndex;
    }

    function excludeWhitelistedAddress(address _account) public onlyOwner {
        require(_account != address(0), "ReflectionToken: Invalid address");
        require(_accountsTier[_account] > 0, "ReflectionToken: Account is not in whitelist");
        _accountsTier[_account] = 0;
    }

    function blacklistAddress(address account) public onlyOwner {
        _isBlacklisted[account] = true;
        _accountsTier[account] = 0;
    }

    function unBlacklistAddress(address account) public onlyOwner {
        _isBlacklisted[account] = false;
    }

    // Review:
    // -　TODO: add conventional comment
    // functions for setting fees
    /**
     * Setter functions for fee configurations
     */

    function setEcoSystemFeePercent(uint256 _tierIndex, uint256 _ecoSystemFee)
    external
    onlyOwner
    checkTierIndex(_tierIndex)
    {
        FeeTier memory tier = _feeTiers[_tierIndex];
        _checkFeesChanged(tier, tier.ecoSystemFee, _ecoSystemFee);
        _feeTiers[_tierIndex].ecoSystemFee = _ecoSystemFee;
        if (_tierIndex == 0) {
            defaultFees.ecoSystemFee = _ecoSystemFee;
        }
    }

    function setLiquidityFeePercent(uint256 _tierIndex, uint256 _liquidityFee)
    external
    onlyOwner
    checkTierIndex(_tierIndex)
    {
        FeeTier memory tier = _feeTiers[_tierIndex];
        _checkFeesChanged(tier, tier.liquidityFee, _liquidityFee);
        _feeTiers[_tierIndex].liquidityFee = _liquidityFee;
        if (_tierIndex == 0) {
            defaultFees.liquidityFee = _liquidityFee;
        }
    }

    function setTaxFeePercent(uint256 _tierIndex, uint256 _taxFee) external onlyOwner checkTierIndex(_tierIndex) {
        FeeTier memory tier = _feeTiers[_tierIndex];
        _checkFeesChanged(tier, tier.taxFee, _taxFee);
        _feeTiers[_tierIndex].taxFee = _taxFee;
        if (_tierIndex == 0) {
            defaultFees.taxFee = _taxFee;
        }
    }

    function setOwnerFeePercent(uint256 _tierIndex, uint256 _ownerFee) external onlyOwner checkTierIndex(_tierIndex) {
        FeeTier memory tier = _feeTiers[_tierIndex];
        _checkFeesChanged(tier, tier.ownerFee, _ownerFee);
        _feeTiers[_tierIndex].ownerFee = _ownerFee;
        if (_tierIndex == 0) {
            defaultFees.ownerFee = _ownerFee;
        }
    }

    function setBurnFeePercent(uint256 _tierIndex, uint256 _burnFee) external onlyOwner checkTierIndex(_tierIndex) {
        FeeTier memory tier = _feeTiers[_tierIndex];
        _checkFeesChanged(tier, tier.burnFee, _burnFee);
        _feeTiers[_tierIndex].burnFee = _burnFee;
        if (_tierIndex == 0) {
            defaultFees.burnFee = _burnFee;
        }
    }

    function setEcoSystemFeeAddress(uint256 _tierIndex, address _ecoSystem)
    external
    onlyOwner
    checkTierIndex(_tierIndex)
    {
        require(_ecoSystem != address(0), "ReflectionToken: Address Zero is not allowed");
        if (!_isExcludedFromReward[_ecoSystem]) _excludeFromReward(_ecoSystem);
        _feeTiers[_tierIndex].ecoSystem = _ecoSystem;
        if (_tierIndex == 0) {
            defaultFees.ecoSystem = _ecoSystem;
        }
    }

    function setOwnerFeeAddress(uint256 _tierIndex, address _owner) external onlyOwner checkTierIndex(_tierIndex) {
        require(_owner != address(0), "ReflectionToken: Address Zero is not allowed");
        if (!_isExcludedFromReward[_owner]) _excludeFromReward(_owner);
        _feeTiers[_tierIndex].owner = _owner;
        if (_tierIndex == 0) {
            defaultFees.owner = _owner;
        }
    }

    // Review:
    // - TODO: Should add comments to explain each arguments in the following style.
    /**
     * @dev addTier is used for configuration of fee Tier.
     * @param _ecoSystemFee TBD
     * @param _liquidityFee TBD
     * @param _taxFee TBD
     * @param _ownerFee TBD
     * @param _burnFee TBD
     * @param _ecoSystem TBD
     * @param _owner TBD
     */
    function addTier(
        uint256 _ecoSystemFee,
        uint256 _liquidityFee,
        uint256 _taxFee,
        uint256 _ownerFee,
        uint256 _burnFee,
        address _ecoSystem,
        address _owner
    ) public onlyOwner {
        _addTier(_ecoSystemFee, _liquidityFee, _taxFee, _ownerFee, _burnFee, _ecoSystem, _owner);
    }

    /**
     * Setter functions related to Uniswap
     */

    function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
        maxTxAmount = _tTotal * maxTxPercent / (10**4);
    }

    function setDefaultSettings() external onlyOwner {
        swapAndEvolveEnabled = true;
    }

    function setSwapAndEvolveEnabled(bool _enabled) public onlyOwner {
        swapAndEvolveEnabled = _enabled;
        emit SwapAndEvolveEnabledUpdated(_enabled);
    }

    function updateRouterAndPair(address _uniswapV2Router, address _uniswapV2Pair) public onlyOwner {
        uniswapV2Router = IUniswapV2Router02(_uniswapV2Router);
        uniswapV2Pair = _uniswapV2Pair;
        WETH = uniswapV2Router.WETH();
    }

    // Review: Doing
    function swapAndEvolve() public onlyOwner lockTheSwap {
        // split the contract balance into halves
        uint256 contractETHBalance = address(this).balance;
        require(contractETHBalance >= amountOfETHToSwapAndEvolve, "ETH balance is not reach for SwapAndEvolve Threshold");

        contractETHBalance = amountOfETHToSwapAndEvolve;

        uint256 half = contractETHBalance / 2;
        uint256 otherHalf = contractETHBalance - half;

        // capture the contract's current ETH balance.
        // this is so that we can capture exactly the amount of ETH that the
        // swap creates, and not make the liquidity event include any ETH that
        // has been manually sent to the contract
        uint256 initialBalance = IReflectionToken(address(this)).balanceOf(msg.sender);
        // swap ETH for Tokens
        _swapETHForTokens(half);

        // how much ETH did we just swap into?
        uint256 newBalance = IReflectionToken(address(this)).balanceOf(msg.sender);
        uint256 swapeedToken = newBalance - initialBalance;

        _approve(msg.sender, address(this), swapeedToken);
        require(IReflectionToken(address(this)).transferFrom(msg.sender, address(this), swapeedToken), "transferFrom is failed");
        // add liquidity to uniswap
        _addLiquidity(swapeedToken, otherHalf);
        emit SwapAndEvolve(half, swapeedToken, otherHalf);
    }

    /**
     * Set functions of addresses and the number of tokens
     */
    
    function setMigrationAddress(address _migration) public onlyOwner {
        migration = _migration;
    }

    function updateBurnAddress(address _newBurnAddress) external onlyOwner {
        burnAddress = _newBurnAddress;
        if (!_isExcludedFromReward[_newBurnAddress]) {
            _excludeFromReward(_newBurnAddress);
        }
    }

    function setNumberOfTokenToCollectETH(uint256 _numToken) public onlyOwner {
        numTokensToCollectETH = _numToken;
    }

    function setNumOfETHToSwapAndEvolve(uint256 _numETH) public onlyOwner {
        amountOfETHToSwapAndEvolve = _numETH;
    }

    // Review:
    // - TODO: who is the amount?
    /**
     * Withdraw functions
     */
    
    // Reivew: Who wiull trigger withdraw function()??
    function withdrawToken(address _token, uint256 _amount) public onlyOwner {
        require(IReflectionToken(_token).transfer(msg.sender, _amount), "transfer is failed");
    }

    function withdrawETH(uint256 _amount) public onlyOwner {
        (bool sent, ) = payable(msg.sender).call{value: (_amount)}("");
        require(sent, "transfer is failed");
    }

    /**
     * Iternal/Private functions
     */

    function _addTier(
        uint256 _ecoSystemFee,
        uint256 _liquidityFee,
        uint256 _taxFee,
        uint256 _ownerFee,
        uint256 _burnFee,
        address _ecoSystem,
        address _owner
    ) internal returns (FeeTier memory) {
        // TODO: _checkFees to what? -> make sure the sum of fee values is less than denominator.
        // TODO: the function name should be _newFeeTier.
        FeeTier memory _newTier = _checkFees(
            FeeTier(_ecoSystemFee, _liquidityFee, _taxFee, _ownerFee, _burnFee, _ecoSystem, _owner)
        );
        if (!_isExcludedFromReward[_ecoSystem]) _excludeFromReward(_ecoSystem);
        if (!_isExcludedFromReward[_owner]) _excludeFromReward(_owner);
        _feeTiers.push(_newTier);

        // TODO: the function name should be _newFeeTier.
        return _newTier;
    }

    // TODO(Bad Naming): should change to rebaseFeeTotals
    function _reflectFee(uint256 rFee, uint256 tFee) private {
        // TODO: modify the fomula simply
        // _rTotal -= rFee;
        // _tFeeTotal += tFee;
        _rTotal = _rTotal - rFee;
        _tFeeTotal = _tFeeTotal + tFee;
    }

    function _removeAllFee() private {
        _previousFees = _feeTiers[0];
        _feeTiers[0] = _emptyFees;
    }

    function _restoreAllFee() private {
        _feeTiers[0] = _previousFees;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    )
    private
    preventBlacklisted(owner, "ReflectionToken: Owner address is blacklisted")
    preventBlacklisted(spender, "ReflectionToken: Spender address is blacklisted")
    {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    // Review: Main function of this contrscat. Should have a proper description of operation.
    /**
     * @dev transfer the Reflection Token deducted from `amount` transferred as the fee.
     */
    function _transfer(
        address from,
        address to,
        uint256 amount
    )
    private
    preventBlacklisted(msg.sender, "ReflectionToken: Address is blacklisted")
    preventBlacklisted(from, "ReflectionToken: From address is blacklisted")
    preventBlacklisted(to, "ReflectionToken: To address is blacklisted")
    isRouter(msg.sender)
    {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        // TODO(Critical): input the balance guard
        // require(balanceOf(from) > amount, "from acount must have greater than amount");
        require(amount > 0, "Transfer amount must be greater than zero");

        if (from != owner() && to != owner())
            require(amount <= maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
        // is the token balance of this contract address over the min number of
        // tokens that we need to initiate a swap + liquidity lock?
        // also, don't get caught in a circular liquidity event.
        // also, don't swap & liquify if sender is uniswap pair.
        uint256 contractTokenBalance = balanceOf(address(this));
        if (contractTokenBalance >= maxTxAmount) {
            contractTokenBalance = maxTxAmount;
        }
        bool overMinTokenBalance = contractTokenBalance >= numTokensToCollectETH;
        if (overMinTokenBalance && !inSwapAndLiquify && from != uniswapV2Pair && swapAndEvolveEnabled) {
            contractTokenBalance = numTokensToCollectETH;
            _collectETH(contractTokenBalance);
        }
        //indicates if fee should be deducted from transfer
        bool takeFee = true;

        //if any account belongs to _isExcludedFromFee account then remove the fee
        if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
            takeFee = false;
        }
        uint256 tierIndex = 0;
        if (takeFee) {
            tierIndex = _accountsTier[from];

            if (msg.sender != from) {
                tierIndex = _accountsTier[msg.sender];
            }
        }
        //transfer amount, it will take tax, burn, liquidity fee
        _tokenTransfer(from, to, amount, tierIndex, takeFee);
    }

    function _collectETH(uint256 contractTokenBalance) private lockTheSwap {
        _swapTokensForETH(contractTokenBalance);
    }

    function _swapTokensForETH(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        // make the swap
        // Review: swapExactTokensForETHSupportingFeeOnTransferTokens?
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    // Review(Bad naming): 
    function _swapETHForTokens(uint256 ethAmount) private {
        // TODO: what is this function doing? geenrate the pair? or conductin the swap?

        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = address(this);
        _approve(owner(), address(uniswapV2Router), ethAmount);
        // make the swap
        uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{ value: ethAmount }(
            0, // accept any amount of Token
            path,
            owner(),
            block.timestamp
        );
    }

    // TODO(Ciritical?): gasLimit should be maximized to 9999999.
    // Cf: https://github.com/Uniswap/v2-periphery/blob/dda62473e2da448bc9cb8f4514dadda4aeede5f4/test/UniswapV2Router02.spec.ts#L16-L18
    function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // add the liquidity
        uniswapV2Router.addLiquidityETH{ value: ethAmount }(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),
            block.timestamp
        );
    }

    // this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 amount,
        uint256 tierIndex,
        bool takeFee
    ) private {
        if (!takeFee) _removeAllFee();

        if (!_isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]) {
            _transferStandard(sender, recipient, amount, tierIndex);
        } else if (_isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]) {
            _transferFromExcluded(sender, recipient, amount, tierIndex);
        } else if (!_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]) {
            _transferToExcluded(sender, recipient, amount, tierIndex);
        } else if (_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]) {
            _transferBothExcluded(sender, recipient, amount, tierIndex);
        }

        if (!takeFee) _restoreAllFee();
    }

    // we update _rTotalExcluded and _tTotalExcluded when add, remove wallet from excluded list
    // or when increase, decrease exclude value
    function _transferBothExcluded(
        address sender,
        address recipient,
        uint256 tAmount,
        uint256 tierIndex
    ) private {
        FeeValues memory _values = _getFeeValues(tAmount, tierIndex);
        // TODO(Critical): need the guard to check for subtractions
        // DONE: modify the fomulas simply
        _tBalance[sender] -= tAmount;
        _rBalance[sender] -= _values.rAmount;
        _tBalance[recipient] += _values.tTransferAmount;
        _rBalance[recipient] += _values.rTransferAmount;

        _tTotalExcluded = _tTotalExcluded + _values.tTransferAmount - tAmount;
        _rTotalExcluded = _rTotalExcluded + _values.rTransferAmount - _values.rAmount;

        _takeFees(sender, _values, tierIndex);
        _reflectFee(_values.rFee, _values.tFee);
        emit Transfer(sender, recipient, _values.tTransferAmount);
    }

    // Review:
    // tAmount is the amount transferred.
    function _transferStandard(
        address sender,
        address recipient,
        uint256 tAmount,
        uint256 tierIndex
    ) private {
        FeeValues memory _values = _getFeeValues(tAmount, tierIndex);
        // TODO(Critical): input the balance guard
        require(_rBalance[sender] > _values.rAmount, "sender's rToken amount is incufficient");
        _rBalance[sender] -= _values.rAmount;
        _rBalance[recipient] += _values.rTransferAmount;
        _takeFees(sender, _values, tierIndex);
        _reflectFee(_values.rFee, _values.tFee);
        emit Transfer(sender, recipient, _values.tTransferAmount);
    }

    // we update _rTotalExcluded and _tTotalExcluded when add, remove wallet from excluded list
    // or when increase, decrease exclude value
    function _transferToExcluded(
        address sender,
        address recipient,
        uint256 tAmount,
        uint256 tierIndex
    ) private {
        FeeValues memory _values = _getFeeValues(tAmount, tierIndex);
        // TODO(Critical): input the balance guard
        require(_rBalance[sender] > _values.rAmount, "sender's rToken amount is incufficient");
        _rBalance[sender] -= _values.rAmount;
        _tBalance[recipient] += _values.tTransferAmount;
        _rBalance[recipient] += _values.rTransferAmount;

        _tTotalExcluded += _values.tTransferAmount;
        _rTotalExcluded += _values.rTransferAmount;

        _takeFees(sender, _values, tierIndex);
        _reflectFee(_values.rFee, _values.tFee);
        emit Transfer(sender, recipient, _values.tTransferAmount);
    }

    // we update _rTotalExcluded and _tTotalExcluded when add, remove wallet from excluded list
    // or when increase, decrease exclude value
    function _transferFromExcluded(
        address sender,
        address recipient,
        uint256 tAmount,
        uint256 tierIndex
    ) private {
        FeeValues memory _values = _getFeeValues(tAmount, tierIndex);
        // TODO(Critical): input the balance guard
        _tBalance[sender] -= tAmount;
        // TODO(Critical): input the balance guard
        _rBalance[sender] -= _values.rAmount;
        _rBalance[recipient] += _values.rTransferAmount;
        _tTotalExcluded -= tAmount;
        _rTotalExcluded -= _values.rAmount;

        _takeFees(sender, _values, tierIndex);
        _reflectFee(_values.rFee, _values.tFee);
        emit Transfer(sender, recipient, _values.tTransferAmount);
    }

    /**
     * @dev transfer fee amount of Reflection Tokens to all fee recipients.
     */
    function _takeFees(
        address sender,
        FeeValues memory values,
        uint256 tierIndex
    ) private {
        _takeFee(sender, values.tLiquidity, address(this));
        _takeFee(sender, values.tEchoSystem, _feeTiers[tierIndex].ecoSystem);
        _takeFee(sender, values.tOwner, _feeTiers[tierIndex].owner);
        _takeBurn(sender, values.tBurn);
    }

    // we update _rTotalExcluded and _tTotalExcluded when add, remove wallet from excluded list
    // or when increase, decrease exclude value
    function _takeFee(
        address sender,
        uint256 tAmount,
        address recipient
    ) private {
        if (recipient == address(0)) return;
        if (tAmount == 0) return;

        // Review: recipient receives `rAmount`.
        uint256 currentRate = _getRSupplyRate();
        uint256 rAmount = tAmount * currentRate;
        // DONE: Modify the coding style simply
        _rBalance[recipient] += rAmount;

        if (_isExcludedFromReward[recipient]) {
            _tBalance[recipient] += tAmount;
            _tTotalExcluded += tAmount;
            _rTotalExcluded += rAmount;
        }

        emit Transfer(sender, recipient, tAmount);
    }

    // we update _rTotalExcluded and _tTotalExcluded when add, remove wallet from excluded list
    // or when increase, decrease exclude value
    function _takeBurn(address sender, uint256 _amount) private {
        if (_amount == 0) return;
        address _burnAddress = burnAddress;
        // TODO: Modify the coding style simply
        // _tBalance[_burnAddress] += _amount;
        _tBalance[_burnAddress] = _tBalance[_burnAddress] + _amount;
        if (_isExcludedFromReward[_burnAddress]) {
            // TODO: Modify the coding style simply
            // _tTotalExcluded += _amount;
            _tTotalExcluded = _tTotalExcluded + _amount;
        }

        emit Transfer(sender, _burnAddress, _amount);
    }

    function _migrate(address account, uint256 amount) private {
        require(account != address(0), "ERC20: mint to the zero address");

        _tokenTransfer(owner(), account, amount, 0, false);
    }

    // Reflection - Read functions

    // external or public

    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcludedFromReward[account];
    }

    // Review:
    // to get the amount of reflection token?
    // - TODO: why tAmount is necessary to get reflection amount?
    function reflectionFromTokenInTiers(
        uint256 tAmount,
        uint256 _tierIndex,
        bool deductTransferFee
    ) public view returns (uint256) {
        // _tTotal means totalSupply?
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            FeeValues memory _values = _getFeeValues(tAmount, _tierIndex);
            return _values.rAmount;
        } else {
            FeeValues memory _values = _getFeeValues(tAmount, _tierIndex);
            return _values.rTransferAmount;
        }
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
        return reflectionFromTokenInTiers(tAmount, 0, deductTransferFee);
    }

    //TODO(Bad naming): changed to getTotalAmountFromReflection
    /**
     * @dev get `total amount` calculated from `reflection Amount`
     */
    function getTotalAmountFromReflection(uint256 rAmount) public view returns (uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total reflections");
        uint256 currentRate = _getRSupplyRate();
        // get tAmount
        return rAmount / currentRate;
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    function accountTier(address _account) public view returns (FeeTier memory) {
        return _feeTiers[_accountsTier[_account]];
    }

    function feeTier(uint256 _tierIndex) public view checkTierIndex(_tierIndex) returns (FeeTier memory) {
        return _feeTiers[_tierIndex];
    }

    function feeTiersLength() public view returns (uint256) {
        return _feeTiers.length;
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function isWhitelisted(address _account) public view returns (bool) {
        return _accountsTier[_account] > 0;
    }

    function isBlacklisted(address account) public view returns (bool) {
        return _isBlacklisted[account];
    }

    function isMigrationStarted() external view override returns (bool) {
        return migration != address(0);
    }

    function getContractBalance() public view returns (uint256) {
        return balanceOf(address(this));
    }

    function getETHBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // internal or private

    // Review: 
    // - DONE(bad naming): getRSupplyRate()
    // Usage: rAmount = tAmount * _getRSupplyRate();
    // - TODO: what ratio ? reflectinAmount/tierAmmount ? 
    function _getRSupplyRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply / tSupply;
    }

    // Review: Idk!
    // - TODO: unclear naming. What supply? token supply? but return value is ratio.
    function _getCurrentSupply() private view returns (uint256, uint256) {
        if (_rTotalExcluded > _rTotal || _tTotalExcluded > _tTotal) {
            return (_rTotal, _tTotal);
        }
        uint256 rSupply = _rTotal - _rTotalExcluded;
        uint256 tSupply = _tTotal - _tTotalExcluded;

        if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);

        // case: rSupply >= _rTotal / _tTotal
        return (rSupply, tSupply);
    }

    // Review:
    // - TODO: the name should be _calculateFeeAmout.
    // _fee is the numerator of fee ratio.
    // - TODO: the name of _fee should be _feeNumerator.
    function _calculateFee(uint256 _amount, uint256 _fee) private pure returns (uint256) {
        if (_fee == 0) return 0;
        // TODO: why no use maxFEE for (10**4)?
        return _amount * _fee / (10**4);
    }

    // Review: 
    // - TODO: What is rTransferFee and rTransferAmount? How different?
    function _getRValues(
        uint256 tAmount,
        uint256 tFee,
        uint256 tTransferFee,
        uint256 currentRate
    )
    private
    pure
    returns (
        uint256,
        uint256,
        uint256
    )
    {
        uint256 rAmount = tAmount * currentRate;
        uint256 rFee = tFee * currentRate;
        uint256 rTransferFee = tTransferFee * currentRate;
        uint256 rTransferAmount = rAmount - rFee - rTransferFee;
        return (rAmount, rTransferAmount, rFee);
    }

    // Review:
    // - tAmount: amountTransferred at transfer() function.
    // DONE(Bad naming): Should change to _getFeeValues
    function _getFeeValues(uint256 tAmount, uint256 _tierIndex) private view returns (FeeValues memory) {
        tFeeValues memory tValues = _getTValues(tAmount, _tierIndex);
        // TODO: what is diff btw tTransferFee and tValues.tFee?
        uint256 tTransferFee = tValues.tLiquidity + tValues.tEchoSystem + tValues.tOwner + tValues.tBurn;
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
            tAmount,
            tValues.tFee,
            tTransferFee,
            _getRSupplyRate()
        );
        return
        FeeValues(
            rAmount,
            rTransferAmount,
            rFee,
            tValues.tTransferAmount,
            tValues.tEchoSystem,
            tValues.tLiquidity,
            tValues.tFee,
            tValues.tOwner,
            tValues.tBurn
        );
    }

    function _getTValues(uint256 tAmount, uint256 _tierIndex) private view returns (tFeeValues memory) {
        FeeTier memory tier = _feeTiers[_tierIndex];
        tFeeValues memory tValues = tFeeValues(
            0,
            _calculateFee(tAmount, tier.ecoSystemFee),
            _calculateFee(tAmount, tier.liquidityFee),
            _calculateFee(tAmount, tier.taxFee),
            _calculateFee(tAmount, tier.ownerFee),
            _calculateFee(tAmount, tier.burnFee)
        );

        // TODO: the name of tTransferAmount shoud be tTransfableAmount.
        tValues.tTransferAmount = tAmount - tValues.tEchoSystem - tValues.tFee - tValues.tLiquidity - tValues.tOwner - tValues.tBurn;

        return tValues;
    }

    // Review: 
    // - Usage: used in addTier()
    // - TODO: Should mention what you're checking.
    // - TODO: Shoud mention that maxFee is the denominator of fee ratio. 1000.
    function _checkFees(FeeTier memory _tier) internal view returns (FeeTier memory) {
        uint256 _fees = _tier.ecoSystemFee + _tier.liquidityFee + _tier.taxFee + _tier.ownerFee + _tier.burnFee;
        require(_fees <= maxFee, "ReflectionToken: Fees exceeded max limitation");

        return _tier;
    }

    function _checkFeesChanged(
        FeeTier memory _tier,
        uint256 _oldFee,
        uint256 _newFee
    ) internal view {
        uint256 _fees = _tier.ecoSystemFee + _tier.liquidityFee + _tier.taxFee + _tier.ownerFee + _tier.burnFee - _oldFee + _newFee;

        require(_fees <= maxFee, "ReflectionToken: Fees exceeded max limitation");
    }

    //to receive ETH from uniswapV2Router when swapping
    receive() external payable {}
}