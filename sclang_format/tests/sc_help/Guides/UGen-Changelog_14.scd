// Source: Guides/UGen-Changelog.schelp block 14
{
	var rate = Impulse.ar(SampleRate.ir/2);
	Sweep.ar(0, rate) * SampleRate.ir
}.loadToFloatArray(2e-4, action: _.postln)
