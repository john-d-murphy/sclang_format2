// Source: Guides/UGen-Changelog.schelp block 5 (part 2/2)
{ IEnvGen.ar(Env([Delay2.ar(Impulse.ar(0), x1: 10, x2: 20)]), 0) }.loadToFloatArray(1e-4, action:_.postln)
