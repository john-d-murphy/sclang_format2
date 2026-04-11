// Source: Guides/Tour_of_UGens.schelp block 66 (part 2/2)
{ Blip.ar(Latch.ar(SinOsc.ar(0.3), Impulse.ar(9)) * 400 + 500, 4, 0.2) }.play;
