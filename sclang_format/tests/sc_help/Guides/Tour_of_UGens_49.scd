// Source: Guides/Tour_of_UGens.schelp block 49
(
{
	// play with the room size
	var x;
	x = Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], Dust.ar(2, 0.1));
	x = Pan2.ar(x, -0.2);
	x = [x[0], DelayC.ar(x[1], 0.01, 0.01)]; // de-correlate
	FreeVerb.ar(x, 0.75, 0.9, 0.4);
}.scope;
)
