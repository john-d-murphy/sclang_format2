// Source: Classes/Env.schelp block 24 (part 1/2)
(
{ SinOsc.ar(
	EnvGen.kr(
		Env([6000, 700, 100], [1, 1], ['exp', 'lin']).circle.postcs)
	) * 0.1
	+ Impulse.ar(1) }.play;
)
