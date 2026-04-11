// Source: Classes/Limiter.schelp block 0 (part 2/2)
(
Synth.play({
	var z;
	z = Decay2.ar(
		Impulse.ar(8, LFSaw.kr(0.25, -0.6, 0.7)),
		0.001, 0.3, FSinOsc.ar(500));
	[z, Limiter.ar(z, 0.4, 0.01)]
}, 0.5)
)
