// Source: Classes/Delay1.schelp block 0 (part 1/2)
(
{
    var z = Dust.ar(1500);
    // [original, subtract delayed from original]
    [z, z - Delay1.ar(z)]
}.plot(0.01)
)
