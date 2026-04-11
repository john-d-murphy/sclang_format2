// Source: Classes/PlayBuf.schelp block 1 (part 7/8)
SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
	var rate;
	rate = LFNoise2.kr(XLine.kr(1, 20, 60), 2);
	Out.ar(out,
		PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * rate, 1, 0, 1)
	)
}).play(s, [\out, 0, \bufnum, b]);
