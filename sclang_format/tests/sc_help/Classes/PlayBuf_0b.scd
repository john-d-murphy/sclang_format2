// Source: Classes/PlayBuf.schelp block 0 (part 2/2)
SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
	Out.ar(out,
		PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: Done.freeSelf)
	)
}).play(s, [\out, 0, \bufnum, b]);
