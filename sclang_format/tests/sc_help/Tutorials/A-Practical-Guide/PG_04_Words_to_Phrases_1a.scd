// Source: Tutorials/A-Practical-Guide/PG_04_Words_to_Phrases.schelp block 1 (part 1/3)
(
SynthDef(\bass, { |out, freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
		detune = 1.005, preamp = 4|
	var	sig,
		env = Env.adsr(0.01, 0.3, 0.4, 0.1);
	freq = Lag.kr(freq, slideTime);
	sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
		* EnvGen.kr(env, gate, doneAction: Done.freeSelf);
	sig = LPF.ar(sig, ffreq);
	Out.ar(out, sig ! 2)
}).add;
)
