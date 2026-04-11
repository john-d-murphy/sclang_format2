// Source: Classes/PulseDivider.schelp block 0
SynthDef("help-PulseDivider",{ arg out=0;
	var p, a, b;
	p = Impulse.ar(8);
	a = SinOsc.ar(1200, 0, Decay2.ar(p, 0.005, 0.1));
	b = SinOsc.ar(600,  0, Decay2.ar(PulseDivider.ar(p, 4), 0.005, 0.5));

	Out.ar(out,(a + b) * 0.4)
}).play;
