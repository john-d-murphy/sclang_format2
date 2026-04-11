// Source: Overviews/Operators.schelp block 23 (part 2/2)
(
SynthDef("help-EnvGen", { arg out=0;
	Out.ar(out,
		EnvGen.kr(Env.perc,1.0,doneAction: Done.freeSelf)
			* SinOsc.ar(440, 0, 0.1)
	)
}).add;

// This synth has no output. It only checks amplitude of input and looks for a transition from < 0.2
// to > 0.2

{ SendTrig.kr(Amplitude.kr(SoundIn.ar(0)) > 0.2) }.play;

// OSCFunc to trigger synth
OSCFunc({ "triggered".postln; Synth.new("help-EnvGen") },'/tr', s.addr);
)
