// Source: Classes/PanAz.schelp block 1
(
{
	[
		PanAz.ar(2, DC.ar(1), Line.ar(-1, 1, 0.1), orientation: 0),
		Pan2.ar(DC.ar(1), Line.ar(-1, 1, 0.1)),
		Pan2.ar(DC.ar(1), EnvGen.ar(Env([1, -1, 1], [0.05, 0.05])))
	].flat;
}.plot(0.1)
)
