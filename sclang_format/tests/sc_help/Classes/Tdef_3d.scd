// Source: Classes/Tdef.schelp block 3 (part 4/9)
(
Tdef(\x, {
	var x;
	x = Pseries(300, 20, 100).loop.asStream;
	loop({
		s.sendMsg("/s_new", "pdef_grainlet", -1,0,0, \freq, x.next);
		0.05.wait;
	})
})
)
