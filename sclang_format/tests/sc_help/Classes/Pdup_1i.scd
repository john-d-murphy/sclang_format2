// Source: Classes/Pdup.schelp block 1 (part 9/10)
c = (2 ** (0..10)).sum { |n| a.dupEach(n.div(2).fin(1)) ++ a.dupEach(n) };
