// Source: Classes/NodeControl.schelp block 0 (part 1/5)
d = SynthDef("help-NodeControl",{ arg out=0,freq=400;
	Out.ar(out,
		 SinOsc.ar(freq, 0, 0.5)
	)
});
