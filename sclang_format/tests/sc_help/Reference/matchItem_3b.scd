// Source: Reference/matchItem.schelp block 3 (part 2/2)
a.any { |x| x.matchItem(3) }; // true
a.any { |x| x.matchItem(4) }; // false
a.any { |x| x.matchItem(10) }; // true
