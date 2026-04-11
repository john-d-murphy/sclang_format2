// Source: Classes/Timer.schelp block 0
(
{ var trig;
	trig = Impulse.kr(MouseX.kr(0.5, 20, 1));
	SinOsc.ar(Timer.kr(trig) * 500 + 500, 0, 0.2)
}.play;
)
