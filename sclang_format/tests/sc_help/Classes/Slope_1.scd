// Source: Classes/Slope.schelp block 1
(
{
    var a, b, c, scale;
    a = LFNoise2.ar(2000);  // quadratic noise
    b = Slope.ar(a);        // first derivative produces line segments
    c = Slope.ar(b);        // second derivative produces constant segments
    scale = 0.0002; // needed to scale back to +/- 1.0
    [a, b * scale, c * scale.squared]
}.plot
)
