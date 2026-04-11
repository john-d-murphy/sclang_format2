// Source: Classes/Klang.schelp block 0 (part 4/5)
(
{
loop({
	play({
		Pan2.ar(Klang.ar(`[ Array.rand(12, 200.0, 2000.0), nil, nil ], 1, 0), 1.0.rand)
			 * EnvGen.kr(Env.sine(4), 1, 0.02, doneAction: Done.freeSelf);
	});
	2.wait;
})
}.fork;
)
