// Source: Classes/Gendy2.schelp block 1 (part 12/18)
( // Gendy1 into Gendy2...with cartoon side effects
{ Pan2.ar(Gendy2.ar(maxfreq: Gendy1.kr(5, 4, 0.3, 0.7, 0.1, MouseY.kr(0.1, 10),
    1.0, 1.0, 5, 5, 500, 600), knum: MouseX.kr(1, 13), mul: 0.2), 0.0) }.play
)
