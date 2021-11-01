// SPDX-License-Identifier: MIT

pragma solidity >=0.6.4;

import './BEP20/BEP20.sol';
import './math/SafeMath.sol';

// KittethCoin - The Coin To Help The Ocean, Environment and Animals of Ireland and Beyond!!!
// A Simple Token - With A Simple Mechanism, Transfer 2% To Charity Wallet, 1% Developer Fee, 1% Burn Fee Until Below Minimum Tokens
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
    uint256 private constant _maxFee = 4;                       // Max Fee Is Only For Clarification For Fees Being Applied
    uint256 private constant _charityFee = 2;                   // Charity Fee Is Initally 2% Once Burn Is Below _minTokens, _burnFee will be applied to Charity Wallet
    uint256 private constant _developerFee = 1;                 // Developer, for every transaction 1% will be transfered to the Developer wallet
    uint256 private constant _burnFee = 1;                      // Burn Fee Is Initally 1% Once Burn Is Below _minTokens, _burnFee will be applied to Charity Wallet

    /* Internal Variables */
    bool private _burnEn = true;                                // Auto Burn Enabled, Only disabled after reaching minimum tokens for circulation
    address private _charityAddress;

    constructor() {
        // Dead Constructor For Placeholding
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
    function transfer(address recipient, uint256 amount) external override returns (bool result) {
        result = false;
        require(amount > 0, "Transfer Amount Is Set To 0"); // Send Message - Caller If Amount Is Set To Zero
        address _sender = _msgSender();
        address _recipient = recipient;
        uint256 _amount = amount;
        uint256 _totalFee = 0;

        // Obtain Values To Various Amounts
        uint256 _charityAmt = _calcFee(_amount, _charityFee);
        uint256 _developAmt = _calcFee(_amount, _developerFee);
        uint256 _burnAmt = _calcFee(_amount, _burnFee);

        // Verify The Amounts Are Less Than the Amount To Send
        _totalFee = _totalFee.add(_charityAmt);
        _totalFee = _totalFee.add(_developAmt);
        _totalFee = _totalFee.add(_burnAmt);
        
        // Check If On The Burn Is Still Enabled
        if (_burnEn) {
            (uint256 _burnToken, bool lastBurn) = _checkBurn(_burnAmt);

            if (lastBurn){ // If Last Burn Was Found
                _charityAmt = _charityAmt.add(_burnToken);
                _burnAmt = _burnAmt.sub(_burnToken);
            }

            require(amount > _totalFee, "Transfer Amount Less Than The _totalAmt");
            _burn(_recipient, _burnAmt);

        } else { // Add Burn Amount To Charity Amount Since 
            _charityAmt = _charityAmt.add(_burnAmt);
        }

        require(amount > _totalFee, "Transfer Amount Less Than The _totalAmt");
        _amount = _amount.sub(_totalFee);
        _transfer(_sender, _recipient, _amount);
        _transfer(_sender, _charityAddress, _charityAmt);
        result = true;
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
            return((_totalSupply - _minTokens), true);
        } else {
            return (0, false);
        }
    }
}
