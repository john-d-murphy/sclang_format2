// Source: Classes/SynthDef.schelp block 10 (part 2/2)
(
~def = SynthDef(\argumentExample, {
	var sig;
	sig = SinOsc.ar(
		\freq.kr(spec:ControlSpec(20, 20000)),
		0,
		\amp.kr(spec:ControlSpec(0, 1));
	);
	Out.ar(0, sig);
});
~def.specs.freq.postln;
~def.specs.amp.postln;
)
