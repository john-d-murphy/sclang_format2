// Source: Classes/Index.schelp block 0 (part 5/6)
(
SynthDef(\help_Index, { |out=0, bufnum=0|
	Out.ar(out,
		SinOsc.ar(
			Index.kr(
				bufnum,
				MouseX.kr(0, BufFrames.ir(i_bufnum))
			),
			0,
			0.5
		)
	)
}).play(s, [\bufnum, b]);
)
