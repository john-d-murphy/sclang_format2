// Source: Classes/Pproto.schelp block 2
(
SynthDef(\shaper, { |out = 0, bufnum = 0, numbufs = 8, sustain = 1, freq = 500, amp = 0.1, pan = 0|
	var audio;
	audio = SinOsc.ar(freq);
	audio = EnvGen.ar(Env.linen(0.4, 0.50, 0.9), 1, timeScale: sustain, doneAction: Done.freeSelf) * audio;
	audio = Shaper.ar(bufnum, audio);
	audio = Pan2.ar(audio, pan, amp);
	OffsetOut.ar(out, LeakDC.ar(audio));
}).add;  // use .store for rendering example below

c = Pproto({
	~bufnum = (type: \cheby, amps: 1.0/[1, 1, 1, 1, 1, 6]).yield;
	},
	Ppar([
		Pbind(*[
			instrument: 	\shaper,
			freq:		Pwhite(1, 16) * 100,
			detune:		Pfunc { Array.fill(3.rand + 1, { 3.0.rand }) },
			dur:		Prand([2, 2, 2.2, 1], inf),
			db:		Pn(Pstep([-10, -20, -20, -15, -20, -20, -20], 0.5)),
			legato:		Pwhite(0.0, 1).linexp(0, 0, 1.1, 5)
		]),
		Pbind(*[
			type:		\cheby,
			amps:		Pseg(Pfunc{ |ev| Array.fill(10, { 1.0.rand }) }, 4),
			dur: 		0.05
		])
	])
);
c.play
)
