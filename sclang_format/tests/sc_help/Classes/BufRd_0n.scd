// Source: Classes/BufRd.schelp block 0 (part 14/18)
(
x = { arg rate=1;
	BufRd.ar(1, b, Phasor.ar(0, BufRateScale.kr(b) * rate, 0, BufFrames.kr(b)))
}.play;
)
