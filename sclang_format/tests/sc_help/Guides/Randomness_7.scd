// Source: Guides/Randomness.schelp block 7
(
var randomNumbers, histogram, maxValue = 500, numVals = 10000, numBins = 500;

randomNumbers = Array.fill(numVals, { maxValue.rand; });
histogram = randomNumbers.histo(numBins, 0, maxValue);
histogram.plot("histogram for rand 0 - " ++ maxValue);
)
