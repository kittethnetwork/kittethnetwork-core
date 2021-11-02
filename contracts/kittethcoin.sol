// SPDX-License-Identifier: MIT

pragma solidity >=0.6.4;

import './BEP20/BEP20.sol';
import './math/SafeMath.sol';

// KittethCoin - The Coin To Help The Ocean, Environment and Animals of Ireland and Beyond!!!
// A Simple Token - With A Simple Mechanism, Transfer 1% To Charity Wallet
// Please feel free to use or audit this code as you see fit!
// BEP20Token(_name, _symbol, _decimal, _totalSupply)
contract KittethCoin is BEP20Token('KittethCoin', 'KITTCOIN', 18, 1000000000000) {
    using SafeMath for uint256;

    /* Declarations */
    /* Constants */
    /* Supply */
    uint256 private constant _tokens = 1000000000000;   //Maximum Amount Of Tokens Allowed In Circulation - 420 Quadrillion Kitteth Coins

    /* CharityFee */
    uint256 private constant _charityFee = 1;                   // Charity Fee Is 2%
    address private constant _charityAddress = 0x566efBa4Cbac49FFC387e97Ebd0622DB01B789BE;

    /* Override Section */
    /* Override Standard Functions From The BEP20Token */

    // Override on the mint function preventing the minting of more tokens, 
    // Preventing dilution of supply
    function mint(uint256 /*amount*/) public override view onlyOwner returns (bool) {
        return true;
    }


    // Override The Transfer Function
    // Modified To Allow For Charity To Be Used
    function transfer(address recipient, uint256 amount) external override returns (bool) {
        require(amount > 0, "Transfer Amount Is Set To 0"); // Send Message - Caller If Amount Is Set To Zero
        address _sender = _msgSender();
        address _recipient = recipient;
        uint256 _amount = amount;
        uint256 _charityAmt = _calcFee(_amount, _charityFee);

        require(amount > _charityAmt, "Transfer Amount Less Than The _charityAmt");
        _amount = _amount.sub(_charityAmt);
        _transfer(_sender, _recipient, _amount);
        _transfer(_sender, _charityAddress, _charityAmt);
        return true;
    }

    /* Standard Functions */
    /* SF - Are Used In This Contract To Give Functionality Not Normally Within A BEP20 Token
    /* Used To Calculate The Tax Fee Due To Integer Maths, Multiply By The Fee, Then Divide By 100 To Get The Percent To Subtract*/
    function _calcFee(uint256 amount, uint256 fee) private pure returns (uint256) {
        return amount.mul(fee).div(100);
    }
}
