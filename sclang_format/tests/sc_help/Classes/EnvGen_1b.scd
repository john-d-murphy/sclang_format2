// Source: Classes/EnvGen.schelp block 1 (part 2/3)
(
{
	var env = Env([0, 1, 0.5, 0.8, 0, 1.2, 0], [0.01, 0.5, 0.02, 0.5, 0.2, 0.5]);
	var gate = Impulse.kr(MouseX.kr(0.2, 3), 0.5);
	var gen = EnvGen.kr(env, gate);
	SinOsc.ar(270, SinOsc.ar(gen * 473)) * gen * 0.2
}.play
)
