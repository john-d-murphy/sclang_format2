// Source: Guides/Tour_of_UGens.schelp block 70 (part 5/8)
z = { arg gate=1; EnvGen.kr(Env.adsr, gate, doneAction: Done.freeSelf) * SinOsc.ar(880,0,0.2) }.play;
