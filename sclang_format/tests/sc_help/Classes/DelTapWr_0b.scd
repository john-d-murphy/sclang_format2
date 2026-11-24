// Source: Classes/DelTapWr.schelp block 0 (part 2/5)
SynthDef(\test, { |out, buffer|
	var src, tapPhase, tap1, tap2, tap3;
	src = WhiteNoise.ar(0.2) * Decay.kr(Dust.kr(3), 0.2);
	tapPhase = DelTapWr.ar(buffer, src);
	#tap1, tap2, tap3 = DelTapRd.ar(buffer, tapPhase,
		[0.2, 0.27, 0.303],  	// tap times
		1,  					// no interp
		[1.0, 0.4, 0.2] 		// muls for each tap
	);
	Out.ar(out, [src + tap2, tap1 + tap3])
}).add;
