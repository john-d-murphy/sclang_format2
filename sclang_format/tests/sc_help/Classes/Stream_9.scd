// Source: Classes/Stream.schelp block 9
(
x = Routine({ arg inval;
	2.do({
		[1,2,3,4].do({ arg i;
			if(inval.isNil) { nil.alwaysYield };
			inval = (i * inval).yield;
		});
	});
});
y = Routine({
	100.yield;
	30.yield;
	4.do { 1.0.rand.yield };
});
z = x <> y;
17.do({ z.value.postln }); // call .value here, as this is a function.
)
