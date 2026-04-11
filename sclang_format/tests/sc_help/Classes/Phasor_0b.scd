// Source: Classes/Phasor.schelp block 0 (part 2/5)
(
{ var trig, rate, x, sr;
	rate = MouseX.kr(1, 200, 1);
	trig = Impulse.ar(rate);
	sr = SampleRate.ir;
	x = Phasor.ar(trig, rate / sr, 0, 1, [0, MouseY.kr(0, 1)]);
	SinOsc.ar(x * 500 + 500, 0, 0.2)
}.play;
)
