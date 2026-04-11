// Source: Classes/Amplitude.schelp block 2
(
// use input amplitude to control SinOsc frequency - use headphones to prevent feedback.
{
    SinOsc.ar(
            Amplitude.kr(
                        SoundIn.ar(0),
                        0.01,
                        0.01,
                        1200,
                        400
            ),
            0, 0.3)
}.play;
)
