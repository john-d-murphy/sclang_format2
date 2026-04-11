// Source: Guides/NodeMessaging.schelp block 6 (part 1/2)
(
SynthDef("grain", {
	Out.ar(0, Line.kr(0.1, 0, 0.01, doneAction: Done.freeSelf) * FSinOsc.ar(12000))
}).send(s);
)
