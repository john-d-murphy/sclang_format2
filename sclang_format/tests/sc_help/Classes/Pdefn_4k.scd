// Source: Classes/Pdefn.schelp block 4 (part 11/11)
(
Pdefn(\deg, Plazy { var pat;
	pat = [Pshuf([0, 3, 2, 7, 6], 2), Pseries(0, 1, 11), Pseries(11, -1, 11)].choose;
	Pn(pat, inf)
});
)
