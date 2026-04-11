// Source: Classes/BufWr.schelp block 0 (part 3/6)
(
x = { arg rate=1;
	BufRd.ar(1, 0, Phasor.ar(0, BufRateScale.kr(0) * rate, 0, BufFrames.kr(0)))
}.play(s);
)
