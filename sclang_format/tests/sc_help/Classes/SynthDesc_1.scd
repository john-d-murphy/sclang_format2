// Source: Classes/SynthDesc.schelp block 1
(
SynthDef("test", { |out, freq, xFade|
	XOut.ar(out, xFade, SinOsc.ar(freq))
}).store
);
