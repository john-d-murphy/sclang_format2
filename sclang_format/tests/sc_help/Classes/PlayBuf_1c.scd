// Source: Classes/PlayBuf.schelp block 1 (part 3/8)
SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
	var trig;
	trig = Impulse.kr(XLine.kr(0.1, 100, 30));
	Out.ar(out,
		PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), trig, 5000, 0)
	)
}).play(s, [\out, 0, \bufnum, b]);
