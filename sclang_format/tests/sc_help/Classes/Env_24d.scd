// Source: Classes/Env.schelp block 24 (part 4/4)
( // Control the gate with MouseX
{
    SinOsc.ar(
        EnvGen.kr(
            Env(
                [6000, 700, 100], [0.5, 0.5], ['exp', 'lin']
            ).circle(1).postcs,
            MouseX.kr > 0.5
        )
    ) * 0.1
    + (SinOsc.ar(280) * Decay.ar(Impulse.ar(1), 0.05) * 0.5)
}.play;
)
