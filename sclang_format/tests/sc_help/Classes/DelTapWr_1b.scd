// Source: Classes/DelTapWr.schelp block 1 (part 2/8)
SynthDef(\write, { |buffer, cout|
	var src, tapPhase, tap1, tap2, tap3;
	src = WhiteNoise.ar(0.2) * Decay.kr(Dust.kr(3), 0.7);
	tapPhase = DelTapWr.ar(buffer, src);
	Out.kr(cout, tapPhase);
	}).add;
