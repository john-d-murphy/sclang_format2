// Source: Tutorials/Mark_Polishook_tutorial/17_Delays_reverbs.schelp block 4 (part 1/3)
(
SynthDef("filteredDust", {
	Out.ar(
		2,
		Mix.arFill(10, { Resonz.ar(Dust.ar(0.2, 50), Rand(200, 3200), 0.003) })
	)
}).add;

SynthDef("preDelay", {
	ReplaceOut.ar(
		4,
		DelayN.ar(In.ar(2, 1), 0.048, 0.048)
	)
}).add;

SynthDef("combs", {
	ReplaceOut.ar(
		6,
		Mix.arFill(7, { CombL.ar(In.ar(4, 1), 0.1, LFNoise1.kr(Rand(0, 0.1), 0.04, 0.05), 15) })
	)
}).add;

SynthDef("allpass", { arg gain = 0.2;
	var source;
	source = In.ar(6, 1);
	4.do({ source = AllpassN.ar(source, 0.050, [Rand(0, 0.05), Rand(0, 0.05)], 1) });
	ReplaceOut.ar(
		8,
		source * gain
	)
}).add;

SynthDef("theMixer", { arg gain = 1;
	ReplaceOut.ar(
		0,
		Mix.ar([In.ar(2, 1), In.ar(8, 2)]) * gain
	)
}).add;
)
