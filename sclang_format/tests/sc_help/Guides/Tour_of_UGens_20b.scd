// Source: Guides/Tour_of_UGens.schelp block 20 (part 2/4)
(
// fill tables 80 to 87
8.do({|i|
	var n, a;
	// generate array of harmonic amplitudes
	n = (i+1)**2; // num harmonics for each table: [1,4,9,16,25,36,49,64]
	a = {|j| ((n-j)/n).squared }.dup(n);
	// fill table
	s.listSendMsg([\b_gen, 80+i, \sine1, 7] ++ a);
});
)
