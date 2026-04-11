// Source: Classes/BufRd.schelp block 0 (part 8/18)
(
x = { arg rate=1, inter=2;
	BufRd.ar(1, b, Phasor.ar(0, BufRateScale.kr(b) * rate, 0, BufFrames.kr(b)), 1, inter)
}.play;
)
