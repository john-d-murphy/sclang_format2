// Source: Classes/Stream.schelp block 7
(
x = Routine({
	2.do({
		[1,2,3,4].do({ arg i; i.yield; });
	});
});
y = Routine({
	100.yield;
	30.yield;
	x.embedInStream;
	440.yield;
	1910.yield;
});
17.do({ y.next.postln });
)
