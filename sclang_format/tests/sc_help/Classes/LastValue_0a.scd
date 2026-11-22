// Source: Classes/LastValue.schelp block 0 (part 1/7)
d = { |freq = 440| SinOsc.ar(LastValue.ar(freq, 20), 0, 0.2) }.play;
