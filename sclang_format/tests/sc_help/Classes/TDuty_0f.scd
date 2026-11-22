// Source: Classes/TDuty.schelp block 0 (part 6/10)
(
SynthDef("delta_demand", { |amp = 0.5, out|
	OffsetOut.ar(out,
		TDuty.ar(Dseq([0]), 0, amp, 2)
	)
}).add;
)
