// Source: Reference/matchItem.schelp block 0 (part 2/2)
a.any { |x| x.matchItem(3) }; // true
a.any { |x| x.matchItem(5) }; // false
a.any { |x| x.matchItem("wort") }; // false, because "wort" == "wort" but not identical.
