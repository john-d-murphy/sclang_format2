// Source: Classes/DigitalIO.schelp block 0
(
SynthDef("help-DigitalIO",{ arg out=0;
    DigitalIO.ar( 0, SinOsc.ar( 10 ),LFPulse.kr( 0.1 ) ).poll;
}).play;
)
