// Source: Classes/LagUD.schelp block 0 (part 1/5)
(
SynthDef(\lagud_help, { |out, freq=300, lagup=1, lagdown=5|
	Out.ar(out,
		SinOsc.ar( // sine wave
			LagUD.kr( // lag the frequency
				freq,
				lagup,
				lagdown
			),
			0, // phase
			0.2 // sine amplitude
		)
	);
}).add;
)
