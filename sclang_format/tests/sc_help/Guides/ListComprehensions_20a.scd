// Source: Guides/ListComprehensions.schelp block 20 (part 1/2)
all {: [x,y], x <- (0..10), (x % 5 == 0) || x.isPowerOfTwo, y <- (1..2), (x+y).even }
