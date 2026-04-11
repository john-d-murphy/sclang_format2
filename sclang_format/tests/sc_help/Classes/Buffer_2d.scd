// Source: Classes/Buffer.schelp block 2 (part 4/9)
(
x = SynthDef(\help_Buffer, { arg out = 0, bufnum;
    Out.ar( out,
	    PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum))
    )
}).play(s,[\bufnum, b]);
)
