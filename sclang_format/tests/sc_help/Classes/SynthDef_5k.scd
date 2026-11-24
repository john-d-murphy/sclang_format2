// Source: Classes/SynthDef.schelp block 5 (part 11/17)
(
SynthDef(\trigTest2, { |out|
	Out.ar(out, SinOsc.ar(\freq.kr(440, 4) + [0, 1], 0, Decay2.kr(\trig.tr, 0.005, 1.0)));
}).add;
)
