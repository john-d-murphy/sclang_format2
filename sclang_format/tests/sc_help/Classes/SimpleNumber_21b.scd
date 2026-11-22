// Source: Classes/SimpleNumber.schelp block 21 (part 2/3)
((0..10) / 10).collect { |num| num.quantize(1, 0.6, 0.5) }.postcs.plot;
