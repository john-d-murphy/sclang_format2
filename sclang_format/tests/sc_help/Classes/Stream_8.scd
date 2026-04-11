// Source: Classes/Stream.schelp block 8
(
x = Routine({
	2.do({
		[1,2,3,4].do({ arg i; i.yield; });
	});
});
y = Routine({
	100.yield;
	30.yield;
});
z = x ++ y;
17.do({ z.next.postln });
)
