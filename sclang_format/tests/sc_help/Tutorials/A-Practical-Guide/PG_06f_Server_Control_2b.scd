// Source: Tutorials/A-Practical-Guide/PG_06f_Server_Control.schelp block 2 (part 2/5)
(
TempoClock.default.tempo = 1;
p = Pproto({
	~buf = (type: \allocRead, path: ExampleFiles.child).yield;
}, Pbind(
	\instrument, \playbuf,
		// access resources in the protoevent by Pkey
	\bufnum, Pkey(\buf),
	\dur, Pwhite(1, 4, inf) * 0.25,
		// upper bound of Pwhite is based on duration
		// so that start + (dur * samplerate) never goes past the buffer's end
	\start, Pwhite(0, 188893 - (Pkey(\dur) * 44100), inf)
)).play;
)
