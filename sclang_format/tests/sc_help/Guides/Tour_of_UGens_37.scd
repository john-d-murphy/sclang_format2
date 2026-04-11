// Source: Guides/Tour_of_UGens.schelp block 37
{ SinOsc.ar(200, 0, 0.2).scaleneg(MouseX.kr(-1,1)) }.scope(1);
