// Source: Classes/EnvGen.schelp block 6 (part 1/3)
(
// a Synth with a multi-node release stage
d = { arg gate=1;
	var env = Env([0,1,0,0.5,0],0.5,-4,releaseNode:1);
	{BrownNoise.ar}.dup * EnvGen.kr(env, gate, doneAction: Done.freeSelf)
}.play;
)
