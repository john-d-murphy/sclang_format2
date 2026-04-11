// Source: Guides/Tour_of_UGens.schelp block 55 (part 2/3)
{ SinOsc.ar(800 + (700 * PlayBuf.ar(1,b, BufRateScale.kr(b),  loop:1)),0,0.3) }.scope(1);
