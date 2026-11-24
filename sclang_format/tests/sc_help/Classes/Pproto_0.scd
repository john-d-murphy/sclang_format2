// Source: Classes/Pproto.schelp block 0
(
SynthDef(\help_playbuf, { |out = 0, bufnum = 0, rate = 1, startPos = 0, amp = 0.1, sustain = 1, pan = 0, loop = 1|
	var audio;
	rate = rate * BufRateScale.ir(bufnum);
	startPos = startPos * BufFrames.ir(bufnum);

	audio = BufRd.ar(1, bufnum, Phasor.ar(0, rate, startPos, BufFrames.ir(bufnum)), 1, 1);
	audio = EnvGen.ar(Env.sine, 1, timeScale: sustain, doneAction: Done.freeSelf) * audio;
	audio = Pan2.ar(audio, pan, amp);
	OffsetOut.ar(out, audio);
}).add;  // use .store for rendering example below

a = Pproto({
	~newgroup = (type: \group).yield;
	~sf1 = (type: \allocRead, path: ExampleFiles.apollo11).yield;
},
	Pbind(*[
		instrument:	\help_playbuf,
		dur:		Pseg([0, 0, 0.25, 0.5, 0.75, 1], 10).linexp(0, 1, 0.01, 2),
		legato:		4,
		startPos:	Pn(Pseg([0, 1], 20), inf),
		rate:		Pwhite(1, 1).midiratio,
		loop:		0,
		group:		Pkey(\newgroup),
		bufnum:		Pkey(\sf1)
	])
);
a.play;
)
