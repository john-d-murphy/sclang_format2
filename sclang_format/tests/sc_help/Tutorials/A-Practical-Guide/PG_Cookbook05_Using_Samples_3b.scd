// Source: Tutorials/A-Practical-Guide/PG_Cookbook05_Using_Samples.schelp block 3 (part 2/4)
(
// WAIT for "done recording" message before doing this
var samplerEvent = Event.default.put(\freq, { ~midinote.midicps / ~sampleBaseFreq });

TempoClock.default.tempo = 1;
p = Pbind(
	\degree, Pwhite(0, 12, inf),
	\dur, Pwrand([0.25, Pn(0.125, 2)], #[0.8, 0.2], inf),
	\amp, Pexprand(0.1, 0.5, inf),
	\sampleBaseFreq, 440,
	\instrument, \sampler,
	\bufnum, b
).play(protoEvent: samplerEvent);
)
