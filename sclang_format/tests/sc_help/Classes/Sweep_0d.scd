// Source: Classes/Sweep.schelp block 0 (part 4/6)
(
{ var trig, pos, rate;
	trig = Impulse.kr(MouseX.kr(0.5, 10, 1));
	rate = BufSampleRate.ir(0);
	pos = Sweep.ar(trig, rate.neg) + (BufFrames.ir(0) * LFNoise0.kr(0.2));
	BufRd.ar(1, b, pos)
}.play;
)
