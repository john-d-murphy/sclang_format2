// Source: Classes/SynthDef.schelp block 2 (part 1/2)
d = SynthDef(\demoWrapping, { |out|
	Out.ar(out, SynthDef.wrap({ |freq| SinOsc.ar(freq) }))
});
