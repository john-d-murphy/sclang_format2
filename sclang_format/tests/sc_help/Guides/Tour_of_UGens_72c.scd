// Source: Guides/Tour_of_UGens.schelp block 72 (part 3/12)
{ var x; x = LPF.ar(BrownNoise.ar(0.2), MouseX.kr(100,10000)); [x,x] }.scope(2);
