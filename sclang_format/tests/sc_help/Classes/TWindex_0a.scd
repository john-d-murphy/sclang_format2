// Source: Classes/TWindex.schelp block 0 (part 1/9)
(
a = SynthDef("help-TWindex", { |out, w1=0.0, w2=0.5, w3=0.5|
	var trig = Impulse.kr(6);
	var index = TWindex.kr(trig, [w1, w2, w3]);
	Out.ar(out,
		SinOsc.ar(
			Select.kr(index,[400, 500, 600]),
			0, 0.2
		)
	)
}).play;
)
