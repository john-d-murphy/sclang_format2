// Source: Classes/Pindex.schelp block 0 (part 1/2)
(
SynthDef(\help_pindex, { | out, amp=0.1, freq=440, gate=1 |
	var son = Saw.ar(freq * [0.99, 1, 1.01]).mean;
	son = son * EnvGen.ar(Env.adsr, gate: gate, doneAction: Done.freeSelf);
	Out.ar(out, son.dup * amp);
}).add;
)
