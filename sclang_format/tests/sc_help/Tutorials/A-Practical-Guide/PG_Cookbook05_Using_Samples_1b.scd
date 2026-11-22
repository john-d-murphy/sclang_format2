// Source: Tutorials/A-Practical-Guide/PG_Cookbook05_Using_Samples.schelp block 1 (part 2/4)
(
var start = 0.404561, end = 3.185917,
beatsInLoop = 4,
originalTempo = beatsInLoop / (end - start);

TempoClock.tempo = originalTempo;

p = Ptpar([
	0, Pbind(
		\instrument, \oneLoop,
		\bufnum, b,
		\amp, 0.4,
		\start, start * b.sampleRate,
		\dur, beatsInLoop,
		\time, Pkey(\dur) / Pfunc { thisThread.clock.tempo },
		\rate, Pfunc { thisThread.clock.tempo / originalTempo }
	),
	0.5, Pn(
		Pfindur(4,
			Pbind(
				\instrument, \bell,
				\accent, Pseq([2, Pn(0, inf)], 1),
				\amp, Pseq([0.3, Pn(0.1, inf)], 1),
				\decayScale, Pseq([6, Pn(1, inf)], 1),
				\dur, Pwrand(#[0.25, 0.5, 0.75, 1], #[2, 3, 1, 1].normalizeSum, inf)
			)
		),
	inf),
	0.5, Pbind(
		\instrument, \bell,
		\accent, -0.6,
		\amp, 0.2,
		\decayScale, 0.1,
		\dur, 1
	)
], 1).play;
)
