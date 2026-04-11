// Source: Classes/TWindex.schelp block 0 (part 5/9)
(

a = SynthDef("help-TWindex", { |out, w1=0.0, w2=0.5|
	var trig = Impulse.kr(6);
	var index = TWindex.kr(
		trig,
		[w1, w2, SinOsc.kr(0.3, 0, 0.5, 0.5)],//modulate probability
		1 //do normalisation
	);

	Out.ar(out,
		SinOsc.ar(
			Select.kr(index,[400, 500, 600]),
			0, 0.2
		)
	)
}).play;

)
