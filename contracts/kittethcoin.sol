// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import './BEP20/BEP20.sol';

// KittethCoin - The Coin To Help The Ocean, Environment and Animals of Ireland and Beyond!!!
// A Simple Token - With A Simple Mechanism, Transfer 1% To Charity Wallet
// Please feel free to use or audit this code as you see fit!
// BEP20Token(_name, _symbol, _decimal, _totalSupply)
contract KittethCoin is BEP20Token {
    /* Declarations */
    /* Constants */
    /* Supply */
    uint256 private constant _tokens = 1000000000000;   //Maximum Amount Of Tokens Allowed In Circulation - 1 Quadrillion Kitteth Coins

    /* CharityFee */
    uint256 private constant _charityFee = 1;           // Charity Fee Is 1%
    address private constant _charityAddress = 0xfFcb326F0f8b245ebb1a0e5cccdb94c4c3433ED0; // Test Address currently - update for the real address

    constructor () BEP20Token('KittethCoin', 'KITTCOIN', 18) {
        _mint(_msgSender(), _tokens);
    }

    /* Override Section */
    /* Override Standard Functions From The BEP20Token */

    // Override The Transfer Function
    // Modified To Allow For Charity To Be Used
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        require(amount > 0, "Transfer Amount Is Set To 0");
        uint256 _charityAmt = _calcFee(amount, _charityFee);
        uint256 _amount = amount - _charityAmt;

        _transfer(_msgSender(), recipient, _amount);
        _transfer(_msgSender(), _charityAddress, _charityAmt);
        return true;
    }

    /* Standard Functions */
    /* SF - Are Used In This Contract To Give Functionality Not Normally Within A BEP20 Token
    /* Used To Calculate The Tax Fee Due To Integer Maths, Multiply By The Fee, Then Divide By 100 To Get The Percent To Subtract*/
    function _calcFee(uint256 amount, uint256 fee) private pure returns (uint256) {
        return ((amount * fee) / 100);
    }
}
