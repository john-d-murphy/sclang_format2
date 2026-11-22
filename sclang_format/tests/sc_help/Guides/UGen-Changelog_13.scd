// Source: Guides/UGen-Changelog.schelp block 13
{ Sweep.ar(Impulse.ar(SampleRate.ir/4)) * SampleRate.ir }.loadToFloatArray(1e-4, action:_.postln)
