// Source: Classes/EnvGen.schelp block 5 (part 1/2)
d = { arg gate=1; {BrownNoise.ar}.dup * EnvGen.kr(Env.asr, gate, doneAction: Done.freeSelf) }.play;
