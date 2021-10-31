// SPDX-License-Identifier: MIT

pragma solidity >=0.6.4;

import './BEP20/BEP20.sol';
import './math/SafeMath.sol';
import './Pancake/IPancakeRouter02.sol';
import './Pancake/IPancakeFactory.sol';
import './Pancake/IPancakePair.sol';

// KittethCoin - The Coin To Help The Ocean, Environment and Animals of Ireland and Beyond!!!
// Please feel free to use or audit this code as you see fit!
// BEP20Token(_name, _symbol, _decimal, _totalSupply)
contract KittethCoin is BEP20Token('KittethCoin', 'KITTCOIN', 18, 420000000000000000) {
    using SafeMath for uint256;

    /* Declarations */
    /* Constants */
    /* Supply */
    uint256 private constant _maxTokens = 420000000000000000;   //Maximum Amount Of Tokens Allowed In Circulation - 420 Quadrillion Kitteth Coins
    uint256 private constant _minTokens = 1000000000000;        //Minimum Amount Of Tokens Allowed In Circulation - 1 Trillion Kitteth Coins

    /* Fees and reflection */
    uint256 private constant _maxFee = 5;                       // Max Fee Is Only For Clarification For Fees Being Applied
    uint256 private constant _charityFee = 2;                   // Charity Fee Is Initally 2% Once Burn Is Below _minTokens, _burnFee will be applied to Charity Wallet
    uint256 private constant _reflectionFee = 2;                   // Reflection, for every transaction 2% will be reflected back at all token holders
    uint256 private constant _burnFee = 1;                      // Burn Fee Is Initally 1% Once Burn Is Below _minTokens, _burnFee will be applied to Charity Wallet

    /* Pancake Swap Variables */
    /* Pancake Router Address is found here - https://docs.pancakeswap.finance/code/smart-contracts/pancakeswap-exchange/router-v2 */
    /* Current Router Address is - 0x10ED43C718714eb63d5aA57B78B54704E256024E */
    address private constant _pancakeRouterAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address public immutable _pancakeLPTokenAddress;            // Address Generated On Creation Of Contract
    IPancakeRouter02 public immutable _pancakeRouter;

    /* Internal Variables */
    bool private _burnEn = true;                                // Auto Burn Enabled, Only disabled after reaching minimum tokens for circulation

    constructor() {
        // Create router variable with Pancake Router Address - If Pancake Swap Is Upreved in Future migration will have to be done under new contract
        _pancakeRouter = IPancakeRouter02(_pancakeRouterAddress);
        // Creation of pancake LP pairing
        _pancakeLPTokenAddress = IPancakeFactory(_pancakeRouter.factory()).createPair(address(this), _pancakeRouter.WETH());
        // Upon Completion with BEP20Token standard library we will have both the PancakeSwap Token, and our minted Tokens!!!
    }

    /* Override Section */
    /* Override Standard Functions From The BEP20Token */

    // Override on the mint function preventing the minting of more tokens, 
    // Preventing dilution of supply
    function mint(uint256 /*amount*/) public override view onlyOwner returns (bool) {
        return true;
    }


    // Override The Transfer Function
    // Modified To Allow For Fees To Be Used
    function transfer(address recipient, uint256 amount) external override returns (bool) {
        require(amount > 0, "Transfer Amount Is Set To 0"); // Send Message - Caller If Amount Is Set To Zero
        address _sender = _msgSender();
        address _recipient = recipient;
        uint256 _amount = amount;
        uint256 _totalAmt = 0;

        // Obtain Values To Various Amounts
        uint256 _charityAmt = _calcFee(_amount, _charityFee);
        uint256 _reflectAmt = _calcFee(_amount, _reflectionFee);
        uint256 _burnAmt = _calcFee(_amount, _burnFee);

        // Verify The Amounts Are Less Than the Amount To Send
        _totalAmt = _totalAmt.add(_charityAmt);
        _totalAmt = _totalAmt.add(_reflectAmt);


        _totalAmt = _totalAmt.add(_burnAmt);

        require(amount > _totalAmt, "Transfer Amount Less Than The _totalAmt");
        _transfer(_sender, _recipient, _charityAmt);
        
        //_transfer(_sender, , _charityAmt);
        _burn(_recipient, _burnAmt);

        //_transfer(_msgSender(), recipient, amount);
        return true;
    }


    /* Standard Functions */
    /* SF - Are Used In This Contract To Give Functionality Not Normally Within A BEP20 Token
    
    /* Used To Calculate The Tax Fee Due To Integer Maths, Multiply By The Fee, Then Divide By 100 To Get The Percent To Subtract*/
    function _calcFee(uint256 amount, uint256 fee) private pure returns (uint256) {
        uint256 _amount = amount.mul(fee).div(100);
        return _amount;
    }

    /* Used To Verify The Burn Amount Against The Total Amount */
    function _checkBurn(uint256 amount) private returns (uint256, bool) {
        /* Used To Verify The Burn Amount Against The Total Amount */
        uint256 _totalSupply = _getTotalSupply();
        // Check If totalSupply - amount is less than minimum number of tokens
        if ((_totalSupply - amount) <= _minTokens) {
            _burnEn = false;                            // Remove
            return((_totalSupply - _minTokens), false);
        } else {
            return (0, true);
        }
    }
}