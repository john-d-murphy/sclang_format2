// Source: Classes/Sweep.schelp block 0 (part 3/6)
(
{ var trig;
	trig = Impulse.kr(MouseX.kr(0.5, 10, 1));
	BufRd.ar(1, b, Sweep.ar(trig, BufSampleRate.ir(0)))
}.play;
)
