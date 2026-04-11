// Source: Tutorials/Streams-Patterns-Events7.schelp block 4
(
Pbind(
	\instrument, \help_SPE4_CFString2,
	\degree, Pseq([0,1,2,4,6,3,4,8],inf),
	\dur, 0.4,
	\octave, 3,
	\amp, 0.03,
	\dorkarg, Pseq([1,0,1],inf) // silence every second note - doesn't work
).play;
)
