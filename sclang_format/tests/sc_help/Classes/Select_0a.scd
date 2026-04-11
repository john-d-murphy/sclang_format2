// Source: Classes/Select.schelp block 0 (part 1/2)
(
SynthDef("help-Select",{ arg out=0;

	var a,cycle;
	a = [
			SinOsc.ar,
			Saw.ar,
			Pulse.ar
		];
	cycle = a.size  * 0.5;
	Out.ar(out,
		Select.ar(LFSaw.kr(1.0,0.0,cycle,cycle),a) * 0.2
	)
}).play;

)
