// Source: Guides/UGen-Changelog.schelp block 21
{ IEnvGen.ar(Env([VarSaw.ar(SampleRate.ir/4)]), 0) }.loadToFloatArray(0.0001, action:_.postln)
