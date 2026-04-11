// Source: Guides/Tour_of_UGens.schelp block 65
(
{
	var trig;
	trig = Dust.ar(2);
	[(Trig1.ar(trig, 0.05) * FSinOsc.ar(600, 0, 0.2)),
	(Trig1.ar(TDelay.ar(trig, 0.1), 0.05) * FSinOsc.ar(800, 0, 0.2))]
}.scope(2, zoom:4);
)
