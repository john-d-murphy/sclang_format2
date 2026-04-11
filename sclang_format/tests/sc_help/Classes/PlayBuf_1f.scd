// Source: Classes/PlayBuf.schelp block 1 (part 6/8)
SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
	var rate;
	rate = FSinOsc.kr(XLine.kr(0.2, 8, 30), 0, 3, 0.6);
	Out.ar(out,
		PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * rate, 1, 0, 1)
	)
}).play(s, [\out, 0, \bufnum, b]);
