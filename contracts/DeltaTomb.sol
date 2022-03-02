// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '@openzeppelin/contracts/utils/math/SafeMath.sol';

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

interface IUniswapV2Router {
  function getAmountsOut(uint256 amountIn, address[] memory path)
    external
    view
    returns (uint256[] memory amounts);
    
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
  
    function swapExactTokensForTokens(
        //amount of tokens we are sending in
        uint256 amountIn,
        //the minimum amount of tokens we want out of the trade
        uint256 amountOutMin,
        //list of token addresses we are going to trade in.  this is necessary to calculate amounts
        address[] calldata path,
        //this is the address we are going to send the output tokens to
        address to,
        //the last time that the trade is valid for
        uint256 deadline
    ) external returns (uint256[] memory amounts);
    
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

interface IUniswapV2Pair {
  function token0() external view returns (address);
  function token1() external view returns (address);
  function swap(
    uint256 amount0Out,
    uint256 amount1Out,
    address to,
    bytes calldata data
  ) external;
}

interface IUniswapV2Factory {
  function getPair(address token0, address token1) external returns (address);
}

contract DeltaTomb {
    using SafeMath for uint;
    address public owner;

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    address private constant UNISWAP_V2_ROUTER = 0xF491e7B69E4244ad4002BC14e878a34207E38c29;

    address private constant WETH = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address private constant TOMB = 0x6c021Ae822BEa943b2E66552bDe1D2696a53fbB7;
        
    constructor() {
        owner = msg.sender;
    }

    function swapAndAddLP() external payable {
        
        uint256 halfValue = msg.value.div(2);
        this.swapExactETHForTokens(WETH, TOMB, halfValue, halfValue, msg.sender);

        IERC20(TOMB).approve(UNISWAP_V2_ROUTER, halfValue); 
        IUniswapV2Router(UNISWAP_V2_ROUTER).addLiquidityETH(TOMB, halfValue, halfValue, halfValue, msg.sender, block.timestamp);
        IERC20(TOMB).transfer(msg.sender, IERC20(TOMB).balanceOf(address(this)));
        payable(msg.sender).transfer(address(this).balance);
    }

    function swapExactETHForTokens(address _tokenIn, address _tokenOut, uint256 _amountIn, uint256 _amountOutMin, address _to) external payable {
        // IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn);
        address[] memory path;
        path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;
        IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactETHForTokens{value: _amountIn}(_amountOutMin, path, _to, block.timestamp);
        
    }

    function witdraw() external payable{
        require(msg.sender == owner);

        payable(msg.sender).transfer(address(this).balance);
    }

        // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}