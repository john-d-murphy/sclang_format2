// Source: Classes/Sweep.schelp block 0 (part 5/6)
(
{ var trig, rate;
	trig = Impulse.kr(MouseX.kr(0.5, 10, 1));
	rate = Sweep.kr(trig, 2) + 0.5;
	BufRd.ar(1, b, Sweep.ar(trig, BufSampleRate.ir(0) * rate))
}.play;
)
