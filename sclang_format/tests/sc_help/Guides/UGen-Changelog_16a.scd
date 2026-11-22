// Source: Guides/UGen-Changelog.schelp block 16 (part 1/2)
{ var sr = SampleRate.ir; TDelay.ar(Impulse.ar(sr/2), 1/sr) }.loadToFloatArray(1e-4, action:_.postln)
