// Source: Guides/Tracing-Processes.schelp block 2 (part 2/3)
(1..n).do { |num| [\before, x].postln; x = x + num.squared; [\after, x].postln;};
