// Source: Guides/Randomness.schelp block 11
(
var randomNumbers, histogram, minValue = -250, maxValue = 250, numVals = 10000, numBins = 500;

randomNumbers = Array.fill(numVals, { maxValue.sum3rand; });
histogram = randomNumbers.histo(numBins, minValue, maxValue);
histogram.plot("histogram for sum3rand " ++ minValue ++ " to " ++ maxValue);
)
