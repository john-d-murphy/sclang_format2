// Source: Guides/Tour_of_UGens.schelp block 72 (part 9/12)
{ var x; x = LFTri.ar(1000,0,Decay2.ar(Impulse.ar(4,0,0.2),0.004,0.2)); [x,x]}.scope(2);
