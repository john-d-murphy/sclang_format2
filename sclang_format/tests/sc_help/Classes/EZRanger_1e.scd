// Source: Classes/EZRanger.schelp block 1 (part 5/9)
(	// example to explore a synthesis idea:
p = ProxySpace.push(s.boot);

q = q ? ();
q.freqRange = [200, 2000];
q.ampRange = [0.1, 1];
q.ringRange = [0.1, 10];
q.numRange = [3, 30];

q.soundfunc = { |dens = 5|
	Splay.ar(
		Array.fill(exprand(q.numRange[0], q.numRange[1]).asInteger, {
			Ringz.ar(
				Dust.ar(dens),
				exprand(q.freqRange[0], q.freqRange[1]),
				exprand(q.ringRange[0], q.ringRange[1]),
				exprand(q.ampRange[0], q.ampRange[1])
			)
		})
	).distort
};
)
