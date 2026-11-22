// Source: Reference/softVol_.schelp block 0 (part 1/3)
Ndef(\test, { |freq=200| Splay.ar(SinOsc.ar(freq * Array.rand(12, 0.95, 1.05))) });
