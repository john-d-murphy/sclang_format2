// Source: Classes/VarLag.schelp block 0
(
// used to lag pitch
{
    SinOsc.ar(                              // sine wave
        VarLag.kr(                            // lag the modulator
            LFPulse.kr(1).range(100,400),   // frequency modulator
            0.2,                            // lag time
            Line.kr(-8, 8, 15, doneAction: Done.freeSelf) // modulate shape
        ),
        0,                                  // sine phase
        0.3                                 // sine amplitude
    )
}.play
)
