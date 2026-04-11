// Source: Reference/randomSeed.schelp block 0 (part 1/4)
(
r = Routine({
	loop({#[1,2,3,4,5].choose.yield })
});
r.randSeed = 1923;
)
