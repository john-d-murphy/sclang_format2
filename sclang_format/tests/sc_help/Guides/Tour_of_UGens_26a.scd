// Source: Guides/Tour_of_UGens.schelp block 26 (part 1/4)
{ LPF.ar(WhiteNoise.ar, MouseX.kr(1e2,2e4,1), 0.2) }.scope(1);
