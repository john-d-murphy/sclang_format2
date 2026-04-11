// Source: Classes/PbindProxy.schelp block 1 (part 1/18)
(
SynthDef("Pdefhelp", { arg out, freq, sustain=1, amp=1, pan;
	var env, u=1;
	env = EnvGen.kr(Env.perc(0.03, sustain), 1, doneAction: Done.freeSelf);
	5.do { var d; d = exprand(0.01, 1); u = SinOsc.ar(d * 300, u, rrand(0.1,1.2) * d, 1) };
	Out.ar(out, Pan2.ar(SinOsc.ar(u + 1 * freq, 0, amp * env), pan));
}).add;
)
