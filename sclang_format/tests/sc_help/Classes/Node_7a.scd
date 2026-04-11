// Source: Classes/Node.schelp block 7 (part 1/2)
x = { arg gate=1; BrownNoise.ar(0.5) * EnvGen.kr(Env.cutoff(1), gate, doneAction: Done.freeSelf) }.play;
