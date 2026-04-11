// Source: Guides/Tour_of_UGens.schelp block 61 (part 1/2)
{ WhiteNoise.ar * Decay2.ar(Impulse.ar(1), 0.2, 0.9, 0.2) }.scope(1, zoom:4);
