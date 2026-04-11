// Source: Tutorials/Streams-Patterns-Events7.schelp block 5
(
Pbind(
	\instrument, \help_SPE4_CFString2,
	\degree, Pseq([0,1,2,4,6,3,4,8],inf),
	\dur, 0.4,
	\octave, 3,
	\amp, 0.03,
	\dorkarg, Pseq([1,0,1],inf), // silence every second note - now works
	\msgFunc, { arg out = 0, freq = 440, amp = 0.1, pan = 0, vol = 1,
			dorkarg = 1;
		[\out, out, \freq, freq, \amp, amp, \pan, pan, \vol, vol,
			\dorkarg, dorkarg];
	}
).play;
)
