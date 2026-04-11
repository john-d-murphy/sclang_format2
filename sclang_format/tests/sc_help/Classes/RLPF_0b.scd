// Source: Classes/RLPF.schelp block 0 (part 2/3)
(
{ var ctl = RLPF.ar(Saw.ar(5, 0.1), 25, 0.03);
	SinOsc.ar(ctl * 200 + 400) * 0.1;
}.play;
)
