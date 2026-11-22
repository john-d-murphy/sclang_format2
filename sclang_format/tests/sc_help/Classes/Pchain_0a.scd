// Source: Classes/Pchain.schelp block 0 (part 1/3)
(
Pchain(
	Pbind(\detune, Pseq([-30, 0, 40], inf), \dur, Prand([0.2, 0.4], inf)),
	Pbind(\degree, Pseq([1, 2, 3], inf), \dur, 1)
).trace.play;
)
