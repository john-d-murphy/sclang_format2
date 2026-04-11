// Source: Classes/AbstractFunction.schelp block 14 (part 1/2)
(
// Add two functions:
var x = { |x| x + 1000 } + { |x| x * 100 };
// Evaluate the result, passing in one argument:
x.value(2); // posts 1202
)
