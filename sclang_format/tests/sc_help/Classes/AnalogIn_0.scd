// Source: Classes/AnalogIn.schelp block 0
(
SynthDef("help-AnalogIn",{ arg out=0;
	Out.ar(out,
	  SinOsc.ar( AnalogIn.ar( 0 ).exprange( 200, 5000 ), 0, 0.1 )
	)
}).play;
)
