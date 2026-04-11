// Source: Classes/Env.schelp block 24 (part 2/2)
(
{ SinOsc.ar(
	EnvGen.kr(
		Env([6000, 700, 100], [1, 1], ['exp', 'lin']).circle(1).postcs,
		MouseX.kr > 0.5)
	) * 0.1
	+ Impulse.ar(1) }.play;
)
