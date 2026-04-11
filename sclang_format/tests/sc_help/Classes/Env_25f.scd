// Source: Classes/Env.schelp block 25 (part 6/6)
(
// Mapping an Env to an exponential frequency range:
{
	SinOsc.ar(EnvGen.ar(Env.perc(0.01, 0.7).exprange(40, 10000), doneAction: Done.freeSelf)) * 0.2;
}.play
)
