// Source: Classes/PlayBuf.schelp block 1 (part 2/8)
SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
	var trig;
	trig = Impulse.kr(2.0);
	Out.ar(out,
		PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), trig, 0, 0)
	)
}).play(s, [\out, 0, \bufnum, b]);
