// Source: Tutorials/Streams-Patterns-Events3.schelp block 0 (part 1/2)
(
SynthDef(\help_SPE3_SimpleSine, { |out, freq=440, sustain=1.0|
	var osc;
	osc = SinOsc.ar( [freq, freq+0.05.rand], 0.5pi )
	* EnvGen.ar(
		Env.perc, doneAction: Done.freeSelf, levelScale: 0.3, timeScale: sustain
	);
	Out.ar(out, osc);
}).add;
)
