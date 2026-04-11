// Source: Classes/Tdef.schelp block 3 (part 7/9)
(
Tdef(\x, {
	var x, dt;
	dt = [0.1, 0.125, 0.05].choose;
	x = Plazy({ Pseries(1300 + 300.rand, 110 + 130.rand, 16) }).asStream;
	x.do({ arg item;
		s.sendMsg("/s_new", "pdef_grainlet", -1,0,0, \freq, item);
		dt.wait;
	})
})
)
