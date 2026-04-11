// Source: Classes/Pause.schelp block 0 (part 3/7)
SynthDef(\b, { |gate = 1| Out.ar(1, PinkNoise.ar(0.3)); Pause.kr(gate, 1001) }).add;
