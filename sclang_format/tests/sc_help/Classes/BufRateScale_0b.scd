// Source: Classes/BufRateScale.schelp block 0 (part 2/2)
(
x = { arg rate=1;
	BufRd.ar(1, b, Phasor.ar(0, BufRateScale.kr(b) * rate, 0, BufFrames.kr(b)))
}.play;
)
