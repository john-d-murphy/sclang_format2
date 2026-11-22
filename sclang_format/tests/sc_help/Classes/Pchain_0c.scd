// Source: Classes/Pchain.schelp block 0 (part 3/3)
(
var a, b;
a = Prand([
	Pbind(\degree, Pseq([0, 1, 3, 5, 6])),
	Pbind(\dur, Pshuf([0.4, 0.3, 0.3]), \degree, Pseq([3, -1]))
], inf);
b = Prand([
	Pbind(\ctranspose, Pn(1, 4)),
	Pbind(\mtranspose, Pn(2, 7))
], inf);
c = Prand([
	Pbind(\detune, Pfuncn({ [0, 10.0].rand }, 5), \legato, 0.2, \dur, 0.2),
	Pbind(\legato, Pseq([0.2, 0.5, 1.5], 2), \dur, 0.3)
], inf);
Pchain(a, b, c).trace.play;
)
