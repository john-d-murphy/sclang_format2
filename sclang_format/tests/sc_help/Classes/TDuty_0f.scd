// Source: Classes/TDuty.schelp block 0 (part 6/7)
(
SynthDef("delta_demand", { arg amp=0.5, out;
	OffsetOut.ar(out,
		TDuty.ar(Dseq([0]), 0, amp, 2)
	)
}).add;
)
