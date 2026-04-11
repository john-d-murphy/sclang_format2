// Source: Classes/LastValue.schelp block 0 (part 1/6)
d = { arg freq=440; SinOsc.ar(LastValue.ar(freq, 20), 0, 0.2) }.play;

d.set(\freq, 400);
