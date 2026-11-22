// Source: Classes/NodeProxy.schelp block 21 (part 1/29)
(
// must have 'out' or 'i_out' argument to work properly
SynthDef("who", { |freq, gate = 1, out = 0, ffreq = 800, amp = 0.1|
	var env;
	env = Env.asr(0.01, amp, 0.5);
	Out.ar(out, Pan2.ar(
		Formant.ar(freq, ffreq, 300, EnvGen.kr(env, gate, doneAction: Done.freeSelf)), Rand(-1.0, 1.0))
	)
}).add;

)
