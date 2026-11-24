// Source: Classes/Harmonics.schelp block 1 (part 4/6)
(
z = SynthDef("help-Osc", { |out = 0, bufnum = 0|
	Out.ar(out,
		Osc.ar(bufnum, 200, 0, 0.5)
	)
});
)
