// Source: Classes/RandSeed.schelp block 0 (part 1/11)
(
{
var noise, filterfreq;
noise = WhiteNoise.ar(0.05 ! 2) + Dust2.ar(70 ! 2);
filterfreq = LFNoise1.kr(3, 5500, 6000);
Resonz.ar(noise * 5, filterfreq, 0.5) + (noise * 0.5)
}.play;
)
