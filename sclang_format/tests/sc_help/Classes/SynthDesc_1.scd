// Source: Classes/SynthDesc.schelp block 1
(
SynthDef("test", { arg out, freq, xFade;
	XOut.ar(out, xFade, SinOsc.ar(freq))
}).store
);
