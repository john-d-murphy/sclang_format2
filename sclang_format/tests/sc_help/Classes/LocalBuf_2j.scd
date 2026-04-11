// Source: Classes/LocalBuf.schelp block 2 (part 10/11)
(
{
var z = Decay.ar(Dust.ar(1.dup, 0.1), 0.3, WhiteNoise.ar);
BufCombC.ar(LocalBuf(SampleRate.ir, 2), z, XLine.kr(0.0001, 0.01, 20), 0.2);
}.play
)
