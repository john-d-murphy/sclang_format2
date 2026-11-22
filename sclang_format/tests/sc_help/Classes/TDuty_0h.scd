// Source: Classes/TDuty.schelp block 0 (part 8/10)
(
SynthDef("delta_demand2", {
	OffsetOut.ar(0,
		TDuty.ar(Dgeom(0.05, 0.9, 20), 0, 0.5, 2)
	)
}).add;
)
