// Source: Classes/PauseSelf.schelp block 0 (part 1/6)
(
SynthDef("pauseSelf-help", { arg out, t_trig;
	PauseSelf.kr(t_trig);
	Out.ar(out, SinOsc.ar(400,0,0.2));
}).add;
)
