// Source: Tutorials/Streams-Patterns-Events7.schelp block 1
(
Pbind(
	\instrument, Prand([\help_SPE7_BerlinB, \help_SPE7_CFString1],inf),
	\degree, Pseq([0,1,2,4,6,3,4,8],inf),
	\dur, 0.8,
	\octave, 3,
	\amp, 0.03
).play; // this returns an EventStreamPlayer
)
