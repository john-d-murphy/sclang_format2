// Source: Classes/PanAz.schelp block 3
(
{
	[
		Pan2.ar(DC.ar(1), Line.ar(-1, 1, 0.1)),
		PanAz.ar(2, DC.ar(1), Line.ar(0, 1, 0.1), orientation: 0)
	].flat
}.plot(0.1)
)
