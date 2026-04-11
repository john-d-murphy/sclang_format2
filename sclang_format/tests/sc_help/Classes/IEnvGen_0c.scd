// Source: Classes/IEnvGen.schelp block 0 (part 3/3)
(
{
	var point = Amplitude.ar(SoundIn.ar(0), 0.01, 0.2);
	// use offset so negative values of SinOsc will map into the Env
	var env = Env.xyc([[0, 330, \exp], [0.5, 440, \exp], [1.0, 1760]]);
	SinOsc.ar(IEnvGen.kr(env, point)) * 0.2
}.play;
)
