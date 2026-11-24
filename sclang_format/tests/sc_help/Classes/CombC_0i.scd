// Source: Classes/CombC.schelp block 0 (part 9/9)
({
	var in, del1, del2, del3, del4;
	in = SoundIn.ar(0);
	del1 = CombC.ar(in, 8, LFNoise2.kr(0.01).range(1, 8), 1);
	del2 = CombC.ar(del1, 8, LFNoise2.kr(0.01).range(1, 8), 1);
	del3 = CombC.ar(del2, 8, LFNoise2.kr(0.01).range(1, 8), 1);
	del4 = CombC.ar(del3, 8, LFNoise2.kr(0.01).range(1, 8), 1);
	(del1 + del2 + del3 + del4)!2;
}.play;
);
