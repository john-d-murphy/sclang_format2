// Source: Tutorials/A-Practical-Guide/PG_03_What_Is_Pbind.schelp block 7 (part 1/2)
SynthDef(\harpsi, { |outbus = 0, freq = 440, amp = 0.1, gate = 1|
	var out;
	out = EnvGen.ar(Env.adsr, gate, doneAction: Done.freeSelf) * amp *
		Pulse.ar(freq, 0.25, 0.75);
	Out.ar(outbus, out ! 2);
}).add;
