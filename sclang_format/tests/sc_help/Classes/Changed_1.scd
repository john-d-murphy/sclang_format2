// Source: Classes/Changed.schelp block 1
(
{
	var changingSignal = LFNoise0.ar(1000);
	var changed = Changed.ar(changingSignal);
	[changingSignal, changed]
}.plot2
);
