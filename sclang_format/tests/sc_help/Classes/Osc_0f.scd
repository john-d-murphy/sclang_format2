// Source: Classes/Osc.schelp block 0 (part 6/6)
(
fork {
	var n = 32;
	50.do {
		b.sine1(Array.rand(n,0,1).cubed, true, true, true);
		0.25.wait;
	};
};
)
