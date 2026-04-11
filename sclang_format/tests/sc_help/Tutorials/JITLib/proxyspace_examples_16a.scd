// Source: Tutorials/JITLib/proxyspace_examples.schelp block 16 (part 1/5)
(
Instr(\test,
	{ arg dens=520, ffreq=7000; Ringz.ar(Dust.ar(dens, [1,1] * 0.1), ffreq, 0.02) }
	);
)
