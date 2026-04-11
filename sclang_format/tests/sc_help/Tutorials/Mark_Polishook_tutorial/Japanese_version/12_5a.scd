// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/12.schelp block 5 (part 1/3)
(
// エンベロープなしのフィルター　ー永遠にとどまる
SynthDef("soundFileFilter", { arg bus = 0, freq = 440, rq = 0.05;
	ReplaceOut.ar(
		bus,
		BPF.ar(			// a bandpass filter
			In.ar(0, 2),
			[freq * 0.99, freq * 1.5],
			rq
		)
	)
}).add;
)
