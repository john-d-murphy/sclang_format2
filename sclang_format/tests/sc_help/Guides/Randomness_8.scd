// Source: Guides/Randomness.schelp block 8
(
var randomNumbers, histogram, maxValue = 500.0, numVals = 10000, numBins = 500;

randomNumbers = Array.fill(numVals, { maxValue.linrand; });
histogram = randomNumbers.histo(numBins, 0, maxValue);
histogram.plot("histogram for linrand 0 - " ++ maxValue);
)
