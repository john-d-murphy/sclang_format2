// Source: Guides/Tour_of_UGens.schelp block 60 (part 1/3)
{ WhiteNoise.ar * Decay.ar(Impulse.ar(1), 0.9, 0.2) }.scope(1, zoom:4);
