// Source: Classes/Stream.schelp block 3
(
	x = Routine({
		4.do({
			[1,2,3,4].do({ arg i; i.yield; });
		});
	});
	17.do({ x.next.postln });
)
