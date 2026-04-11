// Source: Reference/randomSeed.schelp block 1 (part 2/4)
r = { Routine({
	loop({#[1,2,3,4,5].choose.yield })
}) };

Array.fill(7, r.value);
