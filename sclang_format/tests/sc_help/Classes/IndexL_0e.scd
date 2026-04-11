// Source: Classes/IndexL.schelp block 0 (part 5/6)
(
SynthDef(\help_index, { |out = 0, bufnum = 0|
	Out.ar(out,
		SinOsc.ar(
			IndexL.kr(
				bufnum,
				MouseX.kr(0, BufFrames.ir(bufnum))
			),
			0,
			0.5
		)
	)
}).play(s, [\bufnum, b]);
)
