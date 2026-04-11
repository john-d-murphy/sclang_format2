// Source: Tutorials/Getting-Started/13-Buffers.schelp block 2 (part 2/4)
(
x = SynthDef("tutorial-PlayBuf",{ arg out = 0, bufnum;
	Out.ar( out,
		PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum))
	)
}).play(s,[\bufnum, b]);
)
