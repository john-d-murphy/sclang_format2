// Source: Classes/SynthDef.schelp block 5 (part 17/17)
(
Pmono(\trigTest2, *[
	trig: Prand([0, 1], inf), // for random trigger, use trig, not t_trig
	freq: Pwhite(lo: 220, hi: 440, length: 10),
	dur: 1
]).play;
)
