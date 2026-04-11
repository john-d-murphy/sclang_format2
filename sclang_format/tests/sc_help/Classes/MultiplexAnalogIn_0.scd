// Source: Classes/MultiplexAnalogIn.schelp block 0
(
SynthDef("help-MultiplexAnalogIn",{ arg out=0;
	Out.ar(out,
	  SinOsc.ar( MultiplexAnalogIn.ar( 0, 1 ).exprange( 200, 5000 ), 0, 0.1 )
	)
}).play;
)
