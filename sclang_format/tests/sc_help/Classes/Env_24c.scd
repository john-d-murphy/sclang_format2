// Source: Classes/Env.schelp block 24 (part 3/4)
( // Looping frequency modulation
{
    SinOsc.ar(
        EnvGen.kr(
            Env(
                [6000, 700, 100], [1, 1], ['exp', 'lin']
            ).circle.postcs // post internal representation
        )
    ) * 0.1
    // add an audible metronome
    + (SinOsc.ar(280) * Decay.ar(Impulse.ar(1), 0.05) * 0.5)
}.play;
)
