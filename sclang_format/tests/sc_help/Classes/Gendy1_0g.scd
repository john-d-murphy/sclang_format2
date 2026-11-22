// Source: Classes/Gendy1.schelp block 0 (part 7/18)
(
{
    Pan2.ar(
        SinOsc.ar(
            Gendy1.kr(2, 4,
                SinOsc.kr(0.1, 0, 0.49, 0.51),
                SinOsc.kr(0.13, 0, 0.49, 0.51),
                3.4, 3.5,
                SinOsc.kr(0.17, 0, 0.49, 0.51),
                SinOsc.kr(0.19, 0, 0.49, 0.51),
                10, 10, 50, 350),
        0, 0.3),
    0.0)
}.play
)
