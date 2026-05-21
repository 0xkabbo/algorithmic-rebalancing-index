const { ethers } = require("ethers");

/**
 * Calculates the required trade sizes to return a portfolio to its target weights.
 */
function calculateRebalanceOrders(currentBalances, currentPrices, targetWeights) {
    const totalValue = currentBalances.reduce((acc, bal, i) => {
        return acc + (BigInt(bal) * BigInt(currentPrices[i]));
    }, 0n);

    const orders = currentBalances.map((bal, i) => {
        const targetVal = (totalValue * BigInt(targetWeights[i])) / 10000n;
        const currentVal = BigInt(bal) * BigInt(currentPrices[i]);
        return targetVal - currentVal; // Positive = Buy, Negative = Sell
    });

    return orders;
}

module.exports = { calculateRebalanceOrders };
