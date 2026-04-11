// Source: Classes/BufRd.schelp block 0 (part 13/18)
(
y = { arg rate=1;
	var in;
	in = SinOsc.ar(LFNoise1.kr(2, 300, 400), 0, 0.1);
	BufWr.ar(in, b, Phasor.ar(0, BufRateScale.kr(b) * rate, 0, BufFrames.kr(b)));
	0.0 //quiet
}.play;
)
