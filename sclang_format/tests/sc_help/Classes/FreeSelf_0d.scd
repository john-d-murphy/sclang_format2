// Source: Classes/FreeSelf.schelp block 0 (part 4/5)
(
SynthDef("dirac", { |out, amp = 0.1|
	var u;
	u = Impulse.ar(1);
	FreeSelf.kr(u);
	Out.ar(out, u * amp);
		// multiply by amp after using for release, so amp = 0
		// doesn't cause synth buildup.
}).add;
)
