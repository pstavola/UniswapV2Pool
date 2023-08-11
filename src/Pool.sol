// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "v2-periphery/interfaces/IUniswapV2Router02.sol";
import "v2-core/interfaces/IUniswapV2Factory.sol";
import "v2-core/interfaces/IUniswapV2Pair.sol";

import "src/Yin.sol";
import "src/Yang.sol";

/**
 * @title UniswapV2 Pool
 * @author Patrizio Stavola
 * @notice $YIN-$YANG V2 pool 
*/
contract Pool {
    IUniswapV2Router02 public constant router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    IUniswapV2Factory public constant factory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
    Yin public immutable yin;
    Yang public immutable yang;

    constructor(address _yin, address _yang) {
        yin = Yin(_yin);
        yang = Yang(_yang);
    }

    function addLiquidity(uint256 _amountYin, uint256 _amountYang) external returns (uint amount0, uint amount1, uint liquidity)  {
        yin.transferFrom(msg.sender, address(this), _amountYin);
        yang.transferFrom(msg.sender, address(this), _amountYang);

        yin.approve(address(router), _amountYin);
        yang.approve(address(router), _amountYang);
        (amount0, amount1, liquidity) = router.addLiquidity(address(yin), address(yang), _amountYin, _amountYang, 1, 1, address(this), block.timestamp);
    }

    function removeLiquidity(uint256 liquidity) external returns (uint amount0, uint amount1) {
        IUniswapV2Pair pair = IUniswapV2Pair(factory.getPair(address(yin), address(yang)));

        pair.transferFrom(msg.sender, address(this), liquidity);
        pair.approve(address(router), liquidity);

        (amount0, amount1) = router.removeLiquidity(address(yin), address(yang), liquidity, 1, 1, address(this), block.timestamp);

        yin.transfer(msg.sender, amount0);
        yang.transfer(msg.sender, amount1);
    }
    
    function swapSingleHopExactAmountIn(address _tokenIn, address _tokenOut, uint _amountIn, uint _amountOutMin) external returns (uint[] memory amounts) {
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn);
        IERC20(_tokenIn).approve(address(router), _amountIn);

        address[] memory path;
        path = new address[](2);
        path[0] = address(_tokenIn);
        path[1] = address(_tokenOut);
        
        amounts = router.swapExactTokensForTokens(_amountIn, _amountOutMin, path, address(this), block.timestamp);

        IERC20(_tokenOut).transfer(msg.sender, amounts[1]);
        
    }

    function swapSingleHopExactAmountOut(address _tokenOut, address _tokenIn, uint _amountOut, uint _amountInMax) external returns (uint amountIn) {
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountInMax);
        IERC20(_tokenIn).approve(address(router), _amountInMax);

        address[] memory path;
        path = new address[](2);
        path[0] = address(_tokenIn);
        path[1] = address(_tokenOut);
        
        uint[] memory amounts = router.swapTokensForExactTokens(_amountOut, _amountInMax, path, address(this), block.timestamp);

        IERC20(_tokenOut).transfer(msg.sender, _amountOut);
        amountIn = amounts[0];
        
    }

}