// Source: Classes/PlayBuf.schelp block 1 (part 4/8)
SynthDef(\help_PlayBuf, { arg out=0, bufnum=0;
	var trig;
	trig = Impulse.kr(MouseY.kr(0.5, 200, 1));
	Out.ar(out,
		PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), trig, MouseX.kr(0, BufFrames.kr(bufnum)), 1)
	)
}).play(s, [\out, 0, \bufnum, b]);
