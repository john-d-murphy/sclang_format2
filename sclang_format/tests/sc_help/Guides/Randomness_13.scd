// Source: Guides/Randomness.schelp block 13
(
var randomNumbers, histogram, distribution, randomTable, randTableSize=200;
var minValue = -250, maxValue = 250, numVals = 10000, numBins = 500;

// create some random distribution with values between 0 and 1
distribution = Array.fill(randTableSize,
	{ arg i; (i/ randTableSize * 35).sin.max(0) * (i / randTableSize) }
);

// render a randomTable
randomTable = distribution.asRandomTable;

// get random numbers, scale them

randomNumbers = Array.fill(numVals, { randomTable.tableRand * (maxValue - minValue) + minValue; });
histogram = randomNumbers.histo(numBins, minValue, maxValue);


histogram.plot("this is the histogram we got");
distribution.plot("this was the histogram we wanted");
)
