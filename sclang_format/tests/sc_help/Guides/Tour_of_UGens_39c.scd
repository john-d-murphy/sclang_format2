// Source: Guides/Tour_of_UGens.schelp block 39 (part 3/5)
{ Shaper.ar(80, SinOsc.ar(600, 0, MouseX.kr(0,1))) * 0.3; }.scope(1);
