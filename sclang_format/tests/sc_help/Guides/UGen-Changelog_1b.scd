// Source: Guides/UGen-Changelog.schelp block 1 (part 2/2)
{ Decay2.ar(DelayN.ar(Impulse.ar(0), delaytime:1/SampleRate.ir), attackTime: 0) }.loadToFloatArray(1e-4, action:_.postln)
