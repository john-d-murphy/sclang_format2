// Source: Guides/UGen-Changelog.schelp block 16 (part 2/2)
{ var sr = SampleRate.ir; TDelay.ar(Impulse.ar(sr/3), 4/sr)}.loadToFloatArray(1e-3, action:_.postln)
