// Source: Classes/TaskProxy.schelp block 1 (part 5/8)
(
x.source = {
	var x;
	x = Plazy { Pseries(300 + 300.rand, 10 + 30.rand, 10 + 30.rand) }.loop.asStream;
	loop {
		s.sendMsg("/s_new", "pdef_grainlet", -1, 0, 0, \freq, x.next);
		0.05.wait;
	}
}
)
