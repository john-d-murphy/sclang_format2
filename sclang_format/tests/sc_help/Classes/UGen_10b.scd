// Source: Classes/UGen.schelp block 10 (part 2/2)
(
{ Line.ar(-1, 5, 0.1).lincurve(SinOsc.ar(100), SinOsc.ar(130) + 3, -1, 1, clip: nil) }
    .plot(0.1, minval: -15, maxval: 5)
)
