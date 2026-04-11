// Source: Classes/DynKlang.schelp block 0 (part 3/6)
(
SynthDef('help-dynKlang', { |out,
	freqs=#[220, 440, 880, 1760],
	amps=#[0.35, 0.23, 0.12, 0.05],
	phases=#[1, 1.5, 2, 2.5]|

	Out.ar(out, DynKlang.ar(`[freqs, amps, phases]))
}).add
)
