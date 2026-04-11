// Source: Classes/DigitalIn.schelp block 0
(
SynthDef("help-DigitalIn",{ arg out=0;
	Out.ar(out,
	  SinOsc.ar( 500, 0, 0.1 * DigitalIn.ar( 0 ) )
	)
}).play;
)
