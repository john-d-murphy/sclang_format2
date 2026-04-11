// Source: Tutorials/JITLib/proxyspace_examples.schelp block 7 (part 1/5)
(
~out = { arg freqOffest;
	var ctl;
	ctl = Control.names(\array).kr(Array.rand(8, 400, 1000));
	Pan2.ar(Mix(SinOsc.ar(ctl + freqOffest, 0, 0.1 / 8)), LFNoise0.kr(2))
};
)
