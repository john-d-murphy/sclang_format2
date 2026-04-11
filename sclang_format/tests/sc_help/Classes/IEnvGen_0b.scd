// Source: Classes/IEnvGen.schelp block 0 (part 2/3)
(
{
	var sin = SinOsc.ar(440, 0, MouseX.kr(0, 1));
	// use offset so negative values of SinOsc will map into the Env
	var env = Env([-1, -0.7, 0.7, 1], [ 0.8666, 0.2666, 0.8668 ], \lin, offset: -1.0);
	IEnvGen.ar(env, sin) * 0.1
}.play;
)
