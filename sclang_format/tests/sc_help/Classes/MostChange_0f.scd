// Source: Classes/MostChange.schelp block 0 (part 6/10)
(
d = SynthDef("help-MostChange", { |out, freq = 440|
	var sound, internalFreq;
	internalFreq = LFNoise0.ar(0.3, 300, 800);
	sound = SinOsc.ar(
			MostChange.kr(freq, internalFreq)
	);
	Out.ar(out, sound * 0.1)
}).play;
)
