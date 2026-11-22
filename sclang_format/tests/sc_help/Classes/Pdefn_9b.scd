// Source: Classes/Pdefn.schelp block 9 (part 2/17)
(
Pdefn(\z, { |e|
	loop { yield((e.a + e.b) + 0.1.rand.round(0.01)) }
})
);
