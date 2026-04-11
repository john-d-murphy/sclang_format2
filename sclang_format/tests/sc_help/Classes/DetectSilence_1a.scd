// Source: Classes/DetectSilence.schelp block 1 (part 1/5)
(
SynthDef("detectSilence-help", { arg out;
	var z;
	z = SinOsc.ar(Rand(400, 700), 0, LFDNoise3.kr(8).max(0)).softclip * 0.3;
	DetectSilence.ar(z, doneAction: Done.freeSelf);
	Out.ar(out, z);
}).add;
)
