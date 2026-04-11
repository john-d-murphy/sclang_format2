// Source: Classes/Sweep.schelp block 0 (part 1/6)
(
{ var trig;
	trig = Impulse.kr(MouseX.kr(0.5, 20, 1));
	SinOsc.ar(Sweep.kr(trig, 700) + 500, 0, 0.2)
}.play;
)
