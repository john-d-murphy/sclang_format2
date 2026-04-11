// Source: Classes/Env.schelp block 20 (part 2/2)
(
{
	Blip.ar(
		Env({ exprand(3, 2000.0) } ! 18, 0.2, \exp).kr,
		200,
		Env({ rrand(0.1, 0.2) } ! 18 ++ 0, 0.2).kr(2))
	}.play;
)
