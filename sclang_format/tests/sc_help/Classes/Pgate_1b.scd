// Source: Classes/Pgate.schelp block 1 (part 2/2)
(
Pbind(

	\scale,	Scale.minor,
	\foo, Pn(Pseq((0..2)), inf, \step1),
	\degree, Pn(Pseq((0..7).mirror), inf, \step),
	\ctranspose, Pgate(Pwhite(0, 5), inf, \step) + Pgate(Pseq([0, 7, 0, -7], inf), inf, \step1),
	\dur, 0.2
).play
)
