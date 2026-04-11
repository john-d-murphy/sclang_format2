// Source: Classes/EnvGen.schelp block 4 (part 1/5)
(
SynthDef(\stealMe, { |out, gate = 1|
    Out.ar(out, {BrownNoise.ar}.dup * EnvGen.kr(Env.asr, gate, doneAction: Done.freeSelf))
}).add;
)
