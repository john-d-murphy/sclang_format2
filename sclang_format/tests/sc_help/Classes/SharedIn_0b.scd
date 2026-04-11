// Source: Classes/SharedIn.schelp block 0 (part 2/4)
(
SynthDef("help-SharedIn1", {
	Out.ar(0, SinOsc.ar(Lag.kr(SharedIn.kr(0, 1), 0.01), 0, 0.2));
}).add;
SynthDef("help-SharedIn2", {
	Out.ar(1, SinOsc.ar(Lag.kr(SharedIn.kr(0, 1), 0.01, 1.5), 0, 0.2));
}).add;
)
