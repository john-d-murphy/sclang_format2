// Source: Guides/UGen-Changelog.schelp block 12 (part 2/3)
{ PulseDivider.ar(Impulse.ar(SampleRate.ir/2), 1) }.loadToFloatArray(2e-4, action:_.postln)
