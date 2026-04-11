// Source: Tutorials/Mark_Polishook_tutorial/13_BinaryOp_synthesis.schelp block 2
(
{
	Mix.ar(
		// the ugens that will be mixed go into an array
		[
			Saw.ar(500, 0.05),
			Saw.ar(600, 0.06),
			Saw.ar(700, 0.06)
		]
	)
}.scope
)
