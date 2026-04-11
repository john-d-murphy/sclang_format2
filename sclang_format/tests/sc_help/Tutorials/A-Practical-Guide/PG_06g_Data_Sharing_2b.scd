// Source: Tutorials/A-Practical-Guide/PG_06g_Data_Sharing.schelp block 2 (part 2/4)
(
TempoClock.default.tempo = 1;
p = Pfset({
	~buf = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
	0.2.yield;	// sync seems to be incompatible with patterns
	~bufFrames = ~buf.numFrames;
}, Pbind(
	\instrument, \playbuf,
		// access resources in the protoevent by Pkey
	\bufnum, Pkey(\buf),
	\dur, Pwhite(1, 4, inf) * 0.25,
		// upper bound of Pwhite is based on duration
		// so that start + (dur * samplerate) never goes past the buffer's end
	\start, Pwhite(0, Pkey(\bufFrames) - (Pkey(\dur) * 44100), inf)
), { defer(inEnvir { "freeing buffer".postln; ~buf.free }, 1.1) }).play;
)
