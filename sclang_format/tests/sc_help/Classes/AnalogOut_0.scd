// Source: Classes/AnalogOut.schelp block 0
(
SynthDef("help-AnalogOut",{ arg out=0;
    AnalogOut.ar( 0 , SinOsc.ar( 10 ) );
}).play;
)
