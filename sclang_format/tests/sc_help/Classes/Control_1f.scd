// Source: Classes/Control.schelp block 1 (part 6/17)
(
SynthDef(\help_Control_Sines, { arg out=0;
	var sines, control, numsines;
	numsines = 20;
	control = Control.names(\array).kr(Array.rand(numsines, 400.0, 1000.0));
	sines = Mix(SinOsc.ar(control, 0, numsines.reciprocal)) ;
	Out.ar(out, sines ! 2);
}).add
)
