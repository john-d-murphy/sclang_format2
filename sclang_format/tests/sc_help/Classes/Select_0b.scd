// Source: Classes/Select.schelp block 0 (part 2/2)
(
SynthDef("help-Select-2",{ arg out=0;

	var a,s,cycle;
	a = Array.fill(32,{ rrand(30,80) }).midicps;
	a.postln;
	cycle = a.size  * 0.5;

	s = Saw.ar(
			Select.kr(
				LFSaw.kr(1.0,0.0,cycle,cycle),
				a
			),
			0.2
	);
	Out.ar(out,s )
}).play;
)
