// Source: Classes/Phasor.schelp block 0 (part 1/5)
(
{ var trig, rate, x, sr;
	rate = MouseX.kr(0.2, 2, 1);
	trig = Impulse.ar(rate);
	sr = SampleRate.ir;
	x = Phasor.ar(trig, rate / sr);
	SinOsc.ar(
		[
			LinLin.kr(x, 0, 1, 600, 1000), // convert range from 0..1 to 600..1000
			1000 // constant second frequency
		], 0, 0.2)

}.play;
)
