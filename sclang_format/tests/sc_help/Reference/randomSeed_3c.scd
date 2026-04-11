// Source: Reference/randomSeed.schelp block 3 (part 3/7)
(
d = 1250;// seed
t = Task({
	loop({
		x.set(\seed, d, \tbus, 1.0); r.randSeed = d;
		0.1.wait;
		x.set(\tbus, 0.0);
		1.9.wait;
	})
});
)
