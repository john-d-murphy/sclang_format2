// Source: Tutorials/A-Practical-Guide/PG_08_Event_Types_and_Parameters.schelp block 2 (part 1/5)
(
SynthDef(\event_set, { |freq = 440, gate = 1, amp = 0.1, lagTime = 0.1,
		ffreq = 2000, detune = 1.005, out = 0|
	var	sig = Saw.ar(Lag.kr(freq, lagTime) * [1, detune]).sum * amp
			* EnvGen.kr(Env.adsr, gate, doneAction: Done.freeSelf);
	Out.ar(out, sig ! 2);
}).add;
)
