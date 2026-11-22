// Source: Classes/Delay2.schelp block 0 (part 2/2)
(
{
    var freq = 1000;
    var phaseStep = 2pi * freq / s.sampleRate;
    var sine = SinOsc.ar(freq);
    [
        // default: silence before delay
        Delay2.ar(sine),
        // reconstruct predelay samples
        Delay2.ar(sine,
            x1: phaseStep.sin.neg,
            x2: (2 * phaseStep).sin.neg
        )
    ]
}.plot(0.001).plotMode_(\points)
)
