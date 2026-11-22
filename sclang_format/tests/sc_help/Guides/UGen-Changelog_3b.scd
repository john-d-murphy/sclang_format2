// Source: Guides/UGen-Changelog.schelp block 3 (part 2/2)
{ IEnvGen.ar(Env([Delay1.ar(Impulse.ar(0), x1: 10)]), 0) }.loadToFloatArray(1e-4, action:_.postln)
