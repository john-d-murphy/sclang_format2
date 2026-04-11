// Source: Classes/UGen.schelp block 14 (part 2/2)
{ SinOsc.ar(100).lincurve(-1, 1, -1, 1, XLine.kr(-3, -100, 0.1)) * 0.1 }.plot(0.1);
