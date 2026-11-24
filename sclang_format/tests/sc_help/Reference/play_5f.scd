// Source: Reference/play.schelp block 5 (part 6/8)
a = { |freq = 500| HPF.ar(PinkNoise.ar([1, 1] * 0.4), freq) }.play(args: [\freq, 10000]);
