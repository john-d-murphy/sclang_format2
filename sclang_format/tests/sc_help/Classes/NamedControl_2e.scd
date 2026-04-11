// Source: Classes/NamedControl.schelp block 2 (part 5/7)
(
a = {
	var freq = \freq.kr(440);
	SinOsc.ar(freq.lag(3.5)) + Saw.ar(freq.lag(0.05) * 0.5) * 0.1;
}.play;
)
