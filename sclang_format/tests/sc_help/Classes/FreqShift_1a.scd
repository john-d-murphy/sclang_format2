// Source: Classes/FreqShift.schelp block 1 (part 1/6)
(
SynthDef(\frqShift1, { |out, freq, detune=1.5|
	var e1, left, right;
	e1 = EnvGen.ar(Env.new([0, 0.1, 0], [1, 2.3]),1, doneAction: Done.freeSelf);
	left = SinOsc.ar(freq, 0, e1); // original tone
	left = left + FreqShift.ar(left, freq * detune); // shift and add back to original
	right = FreqShift.ar(left, SinOsc.kr(3.23, 0, 5));
	Out.ar(out, [left,right] * 0.1);
}).add;
)
