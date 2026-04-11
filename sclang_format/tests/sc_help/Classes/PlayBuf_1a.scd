// Source: Classes/PlayBuf.schelp block 1 (part 1/8)
SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
	Out.ar(out,
		PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), loop: 1.0)
	)
}).play(s, [\out, 0, \bufnum, b]);
