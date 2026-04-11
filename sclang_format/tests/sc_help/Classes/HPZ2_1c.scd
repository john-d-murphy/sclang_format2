// Source: Classes/HPZ2.schelp block 1 (part 3/3)
(
{
	var changingSignal = LFNoise0.ar(1000);
	var hpz2 = HPZ2.ar(changingSignal);
	[hpz2, hpz2 > 0]
}.plot
);
