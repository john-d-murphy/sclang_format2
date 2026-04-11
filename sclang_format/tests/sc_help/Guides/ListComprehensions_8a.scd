// Source: Guides/ListComprehensions.schelp block 8 (part 1/2)
all {:[y, z], x<-(0..30), var y = x.nthPrime, var z = 2 ** y - 1, z.asInteger.isPrime.not  }
