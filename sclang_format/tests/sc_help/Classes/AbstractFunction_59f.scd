// Source: Classes/AbstractFunction.schelp block 59 (part 6/7)
y = { |x = 0| x * 3 } + { |x = 0| x + 1.0.rand } * { |x = 0| [50, 100].choose + x } + 1.0;
