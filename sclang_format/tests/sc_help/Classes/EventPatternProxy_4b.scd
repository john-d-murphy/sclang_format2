// Source: Classes/EventPatternProxy.schelp block 4 (part 2/28)
(
// load a synthdef
SynthDef("gpdef", {
	arg out=0, freq=440, sustain=0.05, amp=0.1, pan;
	var env;
	env = EnvGen.kr(Env.perc(0.01, sustain), doneAction: Done.freeSelf) * amp;
	Out.ar(out, Pan2.ar(SinOsc.ar(freq, 0, env), pan))
}).add;
)
