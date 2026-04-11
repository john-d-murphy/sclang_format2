// Source: Classes/Amplitude.schelp block 0
(
// use input amplitude to control SinOsc frequency
{
    SinOsc.ar(
            Amplitude.kr(
                        Blip.ar(3, 20) * LFNoise1.kr(0.1).range(0, 1),
                        MouseX.kr(0.001, 1, 1),
                        MouseY.kr(0.001, 1, 1),
                        1200,
                        400
            ),
            0, 0.3)
}.play;
)
