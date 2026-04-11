// Source: Classes/Normalizer.schelp block 0 (part 1/2)
(
// example signal to process
Synth.play({
	var z;
	z = Decay2.ar(
		Impulse.ar(8, LFSaw.kr(0.25, -0.6, 0.7)),
		0.001, 0.3, FSinOsc.ar(500));
}, 0.8)
)
