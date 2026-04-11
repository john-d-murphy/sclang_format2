// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/14.schelp block 1 (part 1/2)
(
SynthDef("preDelay", { arg inbus = 2;
	Out.ar(
		4,
		DelayN.ar(In.ar(inbus, 1), 0.048, 0.048)
	)
}).add;

SynthDef("combs", {
	Out.ar(
		6,
		Mix.arFill(7, { CombL.ar(In.ar(4, 1), 0.1, LFNoise1.kr(Rand(0, 0.1), 0.04, 0.05), 15) })
	)
}).add;

SynthDef("allpass", { arg gain = 0.2;
	var source;
	source = In.ar(6, 1);
	4.do({ source = AllpassN.ar(source, 0.050, [Rand(0, 0.05), Rand(0, 0.05)], 1) });
	Out.ar(
		8,
		source * gain
	)
}).add;

SynthDef("theMixer", { arg gain = 1;
	Out.ar(
		0,
		Mix.ar([In.ar(2, 1), In.ar(8, 2)]) * gain
	)
}).add;
)
