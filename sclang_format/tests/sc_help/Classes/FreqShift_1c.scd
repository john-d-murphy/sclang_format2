// Source: Classes/FreqShift.schelp block 1 (part 3/6)
(
SynthDef(\frqShift1, { |out, freq, detune=0.15|
	var e1, snd, left, right;
	e1 = EnvGen.ar(Env.new([0, 1, 0],[0.02, 3.2]), 1, doneAction: Done.freeSelf);
	snd = Pulse.ar(freq, SinOsc.kr(2.3).range(0.2,0.8), e1); // original tone
	left = FreqShift.ar(snd,XLine.kr(-0.1,-200,2)); // shift and add back to original
	right = FreqShift.ar(snd,XLine.kr(0.1,200,2));
	Out.ar(out, [left, right] * 0.1);
}).add
)
