// Source: Guides/UGen-Changelog.schelp block 17 (part 1/2)
{ Timer.ar(Impulse.ar(SampleRate.ir/2)) * SampleRate.ir }.loadToFloatArray(2e-4, action:_.postln)
