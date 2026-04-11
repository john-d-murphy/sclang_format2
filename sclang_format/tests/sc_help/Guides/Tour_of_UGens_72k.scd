// Source: Guides/Tour_of_UGens.schelp block 72 (part 11/12)
(
// mixing two delays together
// you hear a phasing sound but the sound is still flat.
{ var x; x = BrownNoise.ar(0.2);
	x = Mix.ar([DelayC.ar(x,0.01,0.01),DelayC.ar(x,0.02,MouseX.kr(0,0.02))]);
	[x,x]
}.scope(2);
)
