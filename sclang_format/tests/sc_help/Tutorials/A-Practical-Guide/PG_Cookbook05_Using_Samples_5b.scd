// Source: Tutorials/A-Practical-Guide/PG_Cookbook05_Using_Samples.schelp block 5 (part 2/5)
(
TempoClock.default.tempo = 1;
p = Pbind(
	\instrument, \multiSampler,
	\bufBase, b.first,
	\baseFreqBuf, ~baseBuf,
	\degree, Pseries(0, Prand(#[-2, -1, 1, 2], inf), inf).fold(-11, 11),
	\dur, Pwrand([0.25, Pn(0.125, 2)], #[0.8, 0.2], inf),
	\amp, Pexprand(0.1, 0.5, inf),
	// some important conversions
	// identify the buffer numbers to read
	\freq, Pfunc { |ev| ev.use(ev[\freq]) },
	\bufnum, Pfunc({ |ev| ~midinotes.indexInBetween(ev[\freq].cpsmidi) })
	.clip(0, ~midinotes.size - 1.001)
).play;
)
