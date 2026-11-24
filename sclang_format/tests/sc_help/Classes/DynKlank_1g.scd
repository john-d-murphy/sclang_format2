// Source: Classes/DynKlank.schelp block 1 (part 7/12)
(
SynthDef('help-dynKlank', { |out,
	freqs (#[100, 200, 300, 400]),
	amps (#[1, 0.3, 0.2, 0.05]),
	rings (#[1, 1, 1, 2])|

	Out.ar(out, DynKlank.ar(`[freqs, amps, rings], WhiteNoise.ar * 0.001))
}).add
)
