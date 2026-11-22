// Source: Classes/Pproto.schelp block 1
(
SynthDef(\osc, { |out = 0, bufnum = 0, numbufs = 8, sustain = 1, freq = 500, amp = 0.1, pan = 0|
	var audio;
	audio = Osc.ar(bufnum, freq);
	audio = EnvGen.ar(Env.linen(0.01, 0.90, 0.9), 1, timeScale: sustain, doneAction: Done.freeSelf) * audio;
	audio = Pan2.ar(audio, pan, amp);
	OffsetOut.ar(out, audio);
}).add;  // use .store for rendering example below

b = Pproto({
	~bufnum = (type: \sine1, amps: 1.0/[1, 2, 3, 4, 5, 6]).yield;
	},
	Ppar([
		Pbind(*[
			instrument: 	\osc,
			freq:		Pwhite(1, 16) * 100,
			detune:		Pfunc { Array.fill(3.rand + 1, { 3.0.rand }) },
			dur:		Prand([2, 2, 2.2, 1], 10),
			db:		Pn(Pstep([-10, -20, -20, -15, -20, -20, -20], 0.5)),
			legato:		Pwhite(0.0, 1).linexp(0, 0, 0.1, 3)
		]),
		Pbind(*[
			type:		\sine1,
			amps:		Pseg(Pfunc{ |ev| Array.fill(10, { 1.0.rand }) }, 1),
			numOvertones:	Pseg(Pwhite(0, 9), 10).asInteger,
			amps:		Pfunc{ |ev| ev[\amps].copyRange(0, ev[\numOvertones]) },
			dur: 		0.05,
			bufNum:		Pkey(\bufnum)
		])
	])
);
b.play
)
