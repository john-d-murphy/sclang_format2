// Source: Guides/Tour_of_UGens.schelp block 20 (part 4/4)
(
// allocate and fill tables 80 to 87
8.do({|i|
	// generate array of harmonic amplitudes
	a = {1.0.rand2.cubed }.dup((i+1)*4);
	// fill table
	s.listSendMsg([\b_gen, 80+i, \sine1, 7] ++ a);
});
)
