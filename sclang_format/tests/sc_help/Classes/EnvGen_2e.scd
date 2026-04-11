// Source: Classes/EnvGen.schelp block 2 (part 5/11)
(
SynthDef(\env_help, { | out, gate = 0, freq = 440, doneAction = 0 |
    var z = EnvGen.kr(Env.adsr, gate, doneAction: doneAction) * SinOsc.ar(freq, 0, 0.1);
    Out.ar(out, z)
}).add;
)
