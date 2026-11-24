// Source: Classes/Env.schelp block 18 (part 1/4)
( // Plot the envelope using *circle and -circle
var loopBackTime = 0.06;
{ [
	EnvGen.kr(
		Env.circle([0.5, 1, 0.3], [0.01, 0.03, loopBackTime])
	),
	EnvGen.kr(
		Env.new([0.5, 1, 0.3], [0.01, 0.03]).circle(loopBackTime)
	)
] }.plot(0.1 * 4 - 0.01).plotMode_(\dlines)
)
