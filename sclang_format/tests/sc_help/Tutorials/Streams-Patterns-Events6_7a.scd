// Source: Tutorials/Streams-Patterns-Events6.schelp block 7 (part 1/3)
(
var chord;
chord = Prand([[53, 58, 64],[53, 60, 64],[57,60,65]]);
Paddp(\ctranspose, Prand([-1,0,2,4,5], inf),
	Ppar([
		Pbind(	// melody part
			\dur, Prand([0.2, 0.4, 0.6], inf),
			\midinote, Pxrand([71, 72, 74, 76, 77, 79], 10),
			\db, -26,
			\legato, 1.1
		),
		Pbind(	// harmony part
			\pan, 0.4,
			\dur, Pseq([0.1, 0.5, 0.4, 0.6], 4),
			\midinote, Pseq([chord,\rest,chord,\rest], 4)
		),
		Pbind(	// bass part
			\pan, -0.4,
			\dur, 0.4,
			\midinote, Pseq([38, 45, 38, 36], 4)
		)
	])
).play
)
