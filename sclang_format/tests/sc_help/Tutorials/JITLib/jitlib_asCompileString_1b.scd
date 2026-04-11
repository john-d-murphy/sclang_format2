// Source: Tutorials/JITLib/jitlib_asCompileString.schelp block 1 (part 2/6)
(
~ctl1 = {
	var z = 1;
	4.do { |i| z = z * SinOsc.kr(i.sqrt, i+[0,0.2]) };
	z
};

~ctl2[0] = { LFNoise2.kr([20,20],20) };
~ctl2[1] = {
	LFNoise2.kr([20,20],20) * LFNoise0.kr([20,20],20)
};

~out = {
	SinOsc.ar(~freq.kr, 0, 0.1)
};

~freq[0] = { ~ctl1.kr(2) + ~ctl2.kr(2) + 400 };
~freq[5] = ~ctl1.wrap2(~ctl2) * ~ctl1 / (~ctl2 + ~ctl1);

~pat = Pbind(\freq, Pfunc({ 1.2.rand }));
~z = 9;
~out.set(\freq, 760, \ffreq, 20);
)
