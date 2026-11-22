// Source: Guides/UGen-Changelog.schelp block 17 (part 2/2)
{
	var dt = SampleDur.ir * 4;
	Timer.ar(DelayN.ar(Impulse.ar(SampleRate.ir/2), dt, dt)) * SampleRate.ir
}.loadToFloatArray(2e-4, action:_.postln)
