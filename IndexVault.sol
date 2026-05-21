// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract IndexVault is ERC20, Ownable {
    using SafeERC20 for IERC20;

    address[] public assets;
    mapping(address => uint256) public targetWeights; // Basis points (10000 = 100%)
    
    event Rebalanced(address indexed assetIn, address indexed assetOut, uint256 amount);

    constructor(
        string memory name, 
        string memory symbol, 
        address[] memory _assets, 
        uint256[] memory _weights
    ) ERC20(name, symbol) Ownable(msg.sender) {
        require(_assets.length == _weights.length, "Mismatched inputs");
        assets = _assets;
        for (uint256 i = 0; i < _assets.length; i++) {
            targetWeights[_assets[i]] = _weights[i];
        }
    }

    function deposit(uint256 _amount, address _inputAsset) external {
        // Simplified: User deposits one of the index assets
        IERC20(_inputAsset).safeTransferFrom(msg.sender, address(this), _amount);
        uint256 shares = _amount; // Simplified minting logic
        _mint(msg.sender, shares);
    }

    function executeRebalance(
        address assetOut, 
        address assetIn, 
        uint256 amountOut, 
        uint256 minAmountIn,
        address dexRouter,
        bytes calldata swapData
    ) external onlyOwner {
        IERC20(assetOut).approve(dexRouter, amountOut);
        (bool success, ) = dexRouter.call(swapData);
        require(success, "Swap failed");
        
        emit Rebalanced(assetIn, assetOut, amountOut);
    }
}
