// Source: Classes/SynthDesc.schelp block 6 (part 2/10)
d = SynthDef(\mdDemo, { |out, freq, cutoff, volume, gate = 1|
	var	sig = LPF.ar(Saw.ar(freq, volume), cutoff),
		env = EnvGen.kr(Env.adsr, gate, doneAction: Done.freeSelf);
	Out.ar(out, (sig * env) ! 2)
}).add;
