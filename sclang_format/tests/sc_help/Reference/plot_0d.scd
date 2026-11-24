// Source: Reference/plot.schelp block 0 (part 4/15)
{ |i| { |j| j + 1 * (i + 1) % 6 }.dup(100) }.dup(5).plot("Some 2-d data");
