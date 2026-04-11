// Source: Guides/Tour_of_UGens.schelp block 72 (part 5/12)
(
{ var x;
	x = Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar(7e-3));
	[x,x]
}.scope(2))
