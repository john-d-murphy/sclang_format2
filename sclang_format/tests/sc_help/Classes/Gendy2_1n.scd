// Source: Classes/Gendy2.schelp block 1 (part 14/18)
( // try out near the corners especially
{ Pan2.ar(Gendy2.ar(6, 6, LFPulse.kr(MouseX.kr(0, 200), 0, 0.4, 1.0),
    SinOsc.kr(MouseY.kr(0, 200), 0, 0.5), mul: 0.2), 0.0) }.play
)
