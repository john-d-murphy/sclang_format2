// Source: Tutorials/JITLib/proxyspace_examples.schelp block 14 (part 11/15)
(
SynthDef("staub", { arg out;
	Out.ar(out, Ringz.ar(WhiteNoise.ar(0.01), 1000 * [1,1], 0.001))
}).add; // store the synth def so it is added to the SynthDescLib
)
