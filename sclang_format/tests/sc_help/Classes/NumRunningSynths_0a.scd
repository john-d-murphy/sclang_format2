// Source: Classes/NumRunningSynths.schelp block 0 (part 1/5)
(
SynthDef("numRunning", { arg out;
	Out.ar(out, SinOsc.ar(NumRunningSynths.ir * 200 + 400, 0, 0.1));
}).add;
)
