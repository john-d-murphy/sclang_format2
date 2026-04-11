// Source: Guides/Tour_of_UGens.schelp block 36 (part 3/6)
{ SinOsc.ar(300, 0, MouseX.kr(0.1,80,1)).clip2(1) * 0.2 }.scope(1);
