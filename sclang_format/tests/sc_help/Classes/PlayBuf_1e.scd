// Source: Classes/PlayBuf.schelp block 1 (part 5/8)
SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
	var rate;
	rate = XLine.kr(0.1, 100, 60);
	Out.ar(out,
		PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum)*rate, 1.0, 0.0, 1.0)
	)
}).play(s, [\out, 0, \bufnum, b]);
