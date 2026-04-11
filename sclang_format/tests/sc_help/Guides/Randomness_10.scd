// Source: Guides/Randomness.schelp block 10
(
var randomNumbers, histogram, minValue = 5.0, maxValue = 500, numVals = 10000, numBins = 500;

randomNumbers = Array.fill(numVals, { exprand(minValue, maxValue); });
histogram = randomNumbers.histo(numBins, minValue, maxValue);
histogram.plot("histogram for exprand: " ++ minValue ++ " to " ++ maxValue);
)
