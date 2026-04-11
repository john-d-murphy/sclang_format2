// Source: Classes/Free.schelp block 0 (part 3/10)
SynthDef("b", { arg t_t=0; Out.ar(1, PinkNoise.ar(0.3)); Free.kr(t_t, 1001); }).add;
