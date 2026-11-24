// Source: Tutorials/JITLib/proxyspace_examples.schelp block 13 (part 30/38)
(
~out = { arg trig, dt=1, xfreq=700;
	Decay2.kr(trig, 0.01, dt) * Mix(SinOsc.ar(xfreq * [1.2, 1.3, 0.2]))
};
)
