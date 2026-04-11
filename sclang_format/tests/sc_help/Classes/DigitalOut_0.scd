// Source: Classes/DigitalOut.schelp block 0
(
SynthDef("help-DigitalOut",{ arg out=0;
    DigitalOut.ar( 0, SinOsc.ar( 10 ) );
}).play;
)
