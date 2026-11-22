// Source: Classes/SynthDef.schelp block 9 (part 1/13)
(
SynthDef(\synthDefTest, { |out, gate = 1, freq = 440|
	// doneAction: Done.freeSelf frees the synth when EnvGen is done
	Out.ar(out, SinOsc.ar(freq) * EnvGen.kr(Env.asr(0.1, 0.3, 1.3), gate, doneAction: Done.freeSelf));
}).store; // use store for compatibility with pattern example below
)
