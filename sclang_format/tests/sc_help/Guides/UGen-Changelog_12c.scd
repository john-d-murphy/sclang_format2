// Source: Guides/UGen-Changelog.schelp block 12 (part 3/3)
{ PulseDivider.ar(Impulse.ar(SampleRate.ir/2), div: 2) }.loadToFloatArray(2e-4, action:_.postln)
