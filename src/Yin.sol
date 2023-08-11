// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title UniswapV2 Pool
 * @author Patrizio Stavola
 * @notice $YIN token 
*/
contract Yin is ERC20 {

    constructor() ERC20("Yin", "YIN") {}

    /**
     * @notice wrapper for the _mint function. Only Owner can mint tokens
     * @param _minter address of the user to mint
     * @param _amount amount of tokens to mint
    */
    function mint(address _minter, uint256 _amount) public {
        super._mint(_minter , _amount);
    }

    /**
     * @notice wrapper for the _burn function. Only Owner can burn tokens
     * @param _account address of the user burning
     * @param _amount amount of tokens to burn
    */
    function burn(address _account, uint256 _amount) public {
        super._burn(_account , _amount);
    }
}