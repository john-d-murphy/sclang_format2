// Source: Classes/HPZ1.schelp block 1 (part 3/3)
(
{
	var changingSignal = LFNoise0.ar(1000);
	var hpz1 = HPZ1.ar(changingSignal);
	[hpz1, hpz1 > 0, hpz1.abs > 0]
}.plot
);
