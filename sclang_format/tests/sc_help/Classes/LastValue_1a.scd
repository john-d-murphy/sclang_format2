// Source: Classes/LastValue.schelp block 1 (part 1/7)
(
d = { arg out=0, val=1;
	SinOsc.ar(
			abs(val - LastValue.kr(val)) * 400 + 200,
			0, 0.2
	)
}.play;
)
