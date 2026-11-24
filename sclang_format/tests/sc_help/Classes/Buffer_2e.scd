// Source: Classes/Buffer.schelp block 2 (part 5/10)
(
x = SynthDef(\help_Buffer, { |out = 0, bufnum|
    Out.ar(out,
	    PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum))
    )
}).play(s, [\bufnum, b]);
)
