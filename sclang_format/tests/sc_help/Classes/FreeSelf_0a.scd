// Source: Classes/FreeSelf.schelp block 0 (part 1/5)
(
SynthDef("freeSelf-help", { |out, t_trig|
	FreeSelf.kr(t_trig);
	Out.ar(out, SinOsc.ar(400, 0, 0.2));
}).add;
)
