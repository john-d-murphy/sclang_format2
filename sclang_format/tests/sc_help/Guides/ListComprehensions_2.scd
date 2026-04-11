// Source: Guides/ListComprehensions.schelp block 2
all(Routine.new({ (1..5).do {|x| (1..x).do {|y| if ((x+y).isPrime) {[x,y].yield} }}}));
