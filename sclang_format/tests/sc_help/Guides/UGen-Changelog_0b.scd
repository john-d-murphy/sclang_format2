// Source: Guides/UGen-Changelog.schelp block 0 (part 2/2)
{ Decay.ar(DelayN.ar(Impulse.ar(0), delaytime:1/SampleRate.ir)) }.loadToFloatArray(1e-4, action:_.postln)
