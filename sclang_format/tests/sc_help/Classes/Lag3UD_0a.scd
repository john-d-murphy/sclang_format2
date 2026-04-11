// Source: Classes/Lag3UD.schelp block 0 (part 1/5)
(
SynthDef( \lag3ud_help, { |out, freq=300, lagup=1, lagdown=5|
	Out.ar(out,
		SinOsc.ar( // sine wave
			Lag3UD.kr( // lag the frequency
				freq,
				lagup,
				lagdown
			),
			0, // phase
			0.2 // sine amplitude
		)
	)
}).add;
)
