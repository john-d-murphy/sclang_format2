// Source: Classes/SynthDef.schelp block 5 (part 6/17)
(
Pmono(\trigTest1, *[
	trig: Prand([0, 1], inf), // for random trigger, use trig, not t_trig
	freq: Pwhite(lo: 220, hi: 440, length: 10),
	dur: 1
]).play;
)
