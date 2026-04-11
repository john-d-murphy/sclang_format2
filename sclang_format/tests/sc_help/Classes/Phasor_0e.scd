// Source: Classes/Phasor.schelp block 0 (part 5/5)
(
{ var trig, rate, framesInBuffer;
	rate = MouseX.kr(0.1, 100, 1);
	trig = Impulse.ar(rate);
	framesInBuffer = BufFrames.kr(b.bufnum);
	x = Phasor.ar(trig, BufRateScale.kr(b.bufnum), 0, framesInBuffer,
		[0, MouseY.kr(0, framesInBuffer)]);
	BufRd.ar(1, b.bufnum, x);
}.play;
)
