// Source: Guides/Multichannel-Expansion.schelp block 11
(
SynthDef("help_multichannel", { |out=0, freq=440, mod=0.1, modrange=20|
	Out.ar(out,
		SinOsc.ar(
			LFPar.kr(mod, 0, modrange) + freq
		) * EnvGate(0.1)
	)
}).add;
)
