// Source: Classes/SynthDef.schelp block 10 (part 1/2)
(
~def = SynthDef(\argumentExample, { |freq, amp|
	var sig;
	freq.spec = ControlSpec(20, 20000, \exp);
	amp.spec = ControlSpec(0, 1);
	sig = SinOsc.ar(freq, 0, amp);
	Out.ar(0, sig);
});
~def.specs.freq.postln;
~def.specs.amp.postln;
)
