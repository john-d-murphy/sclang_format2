// Source: Classes/Tdef.schelp block 3 (part 5/9)
(
Tdef(\x, {
	var x;
	x = Plazy({ Pseries(300 + 300.rand, 10 + 30.rand, 10 + 30.rand) }).loop.asStream;
	loop({
		s.sendMsg("/s_new", "pdef_grainlet", -1,0,0, \freq, x.next);
		0.05.wait;
	})
})
)
