// Source: Guides/Tracing-Processes.schelp block 3 (part 2/3)
(1..n).do { |num| x = x + num.squared; "num: % num-squared: % new x: %\n".postf(num, num.squared, x) };
