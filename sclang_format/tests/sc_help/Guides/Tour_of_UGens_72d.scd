// Source: Guides/Tour_of_UGens.schelp block 72 (part 4/12)
{ LPF.ar({BrownNoise.ar(0.2)}.dup, MouseX.kr(100,10000)) }.scope(2);
