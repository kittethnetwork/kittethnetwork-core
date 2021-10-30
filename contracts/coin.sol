// SPDX-License-Identifier: MIT

pragma solidity >=0.6.4;

import './BEP20/BEP20.sol';
import './math/SafeMath.sol';

// KittethCoin - The Coin To Help The Ocean, Environment and Animals of Ireland and Beyond!!!
// Please feel free to use or audit this code as you see fit!
contract KittethCoin is BEP20Token('KittethCoin', 'KITTCOIN', 18, 420000000000000000) {
    using SafeMath for uint256;

    /* Declarations */
    /* Constants */
    /* Supply */
    uint256 constant _maxTokens = 420000000000000000;   //Maximum Amount Of Tokens Allowed In Circulation - 420 Quadrillion Kitteth Coins
    uint256 constant _minTokens = 1000000000000;        //Minimum Amount Of Tokens Allowed In Circulation - 1 Trillion Kitteth Coins

    /* Fees and reflection */
    uint256 constant _maxFee = 5;                       // Max Fee Is Only For Clarification For Fees Being Applied
    uint256 constant _charityFee = 1;                   // Charity Fee Is Initally 1% Once Burn Is Below _minTokens, _burnFee will be applied to Charity Wallet
    uint256 constant _reflection = 2;                   // Reflection, for every transaction 2% will be reflected back at all token holders
    uint256 constant _burnFee = 2;                      // Burn Fee Is Initally 2% Once Burn Is Below _minTokens, _burnFee will be applied to Charity Wallet

    
    // Override on the mint function preventing the minting of more tokens, 
    // Preventing dilution of supply
    function mint(uint256 amount) public override onlyOwner returns (bool) {
        return true;
    }

    /* Used To Calculate The Tax Fee Due To Integer Maths, Multiply By The Fee, Then Divide By 100 To Get The Percent To Subtract*/
    function _calcFee(uint256 _amount, uint256 _fee) private view returns (uint256) {
        return _amount.mul(_fee).div(100);
    }  
}