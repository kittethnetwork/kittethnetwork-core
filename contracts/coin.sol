// SPDX-License-Identifier: MIT

pragma solidity >=0.6.4;

import './BEP20/BEP20.sol';
import './math/SafeMath.sol';

// KittethCoin
contract KittethCoin is BEP20Token('KittethCoin', 'Kitt', 18, 2000000000) {
    using SafeMath for uint256;
    
    uint256 constant _maxFee = 10;
    
    uint256 public _taxFee = 5;
    uint256 private _previousTaxFee = _taxFee;
    
    uint256 public _liquidityFee = 5;
    uint256 private _previousLiquidityFee = _liquidityFee;

    // Override on the mint function preventing the minting of more tokens, 
    // Preventing dilution of supply
    function mint(uint256 amount) public override onlyOwner returns (bool) {
        return true;
    }

    /* Prevent The Setting Of The Fee To High, Preventing Total Loss On Transfers */
    function setTaxFeePercent(uint256 fee) external onlyOwner returns (bool) {
        if (fee <= _maxFee) {
            _taxFee = fee;
            return true;
        } else {
            return false;
        }
    }
    
    /* Prevent The Setting Of The Fee To High, Preventing Total Loss On Transfers */
    function setLiquidityFeePercent(uint256 fee) external onlyOwner returns (bool) {
        if (fee <= _maxFee) {
            _liquidityFee = fee;
            return true;
        } else {
            return false;
        }
    }

    /* Used To Calculate The Tax Fee */
    function calcTaxFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_taxFee).div(1e2);
    }

    /* Used To Calculate The Liquidity Fee Used To Generate Liquidity In PancakeSwap */
    function calcLiquidityFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_liquidityFee).div(1e2);
    }    
}