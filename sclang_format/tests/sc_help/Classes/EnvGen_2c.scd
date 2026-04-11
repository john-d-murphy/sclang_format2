// Source: Classes/EnvGen.schelp block 2 (part 3/11)
(
SynthDef(\env_help, { | out, gate = 0, freq = 440 |
    var z;
    z = EnvGen.kr(Env.perc, doneAction: Done.freeSelf) * SinOsc.ar(freq, 0, 0.1);
    Out.ar(out, z)
}).add;
)
