// Source: Classes/MIDIIn.schelp block 3 (part 3/8)
(
SynthDef("sik-goo", { |out, freq = 440, formfreq = 100, gate = 0.0, bwfreq = 800|
	var x;
	x = Formant.ar(
		SinOsc.kr(0.02, 0, 10, freq),
		formfreq,
		bwfreq
	);
	x = EnvGen.kr(Env.adsr, gate, Latch.kr(gate, gate)) * x;
	Out.ar(out, x);
}).add;
)
