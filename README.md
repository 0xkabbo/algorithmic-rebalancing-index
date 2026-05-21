# Algorithmic Rebalancing Index

This repository provides an expert-level implementation of an on-chain Index Fund. It allows users to gain exposure to a basket of assets (e.g., a "DeFi Blue Chip" index) while the protocol automatically handles the rebalancing of weights based on pre-defined mathematical rules.

### Core Architecture
* **Index Vault:** Holds the underlying ERC20 assets and issues "Index Shares" to users.
* **Rebalancing Logic:** Triggered when asset prices drift beyond a specific threshold (e.g., 5% deviation from target weights).
* **Swap Integration:** Uses DEX aggregators to swap overweight assets for underweight assets in a single, gas-efficient transaction.
* **Streaming Fees:** Implements automated management fee collection proportional to the time assets spend in the vault.

### Key Features
* **Threshold Rebalancing:** Minimizes gas costs by only trading when deviation is significant.
* **Slippage Protection:** Ensures rebalancing trades are executed within strict price impact limits.
* **Flash Loan Resilience:** Uses TWAP oracles to prevent price manipulation during the rebalancing window.
