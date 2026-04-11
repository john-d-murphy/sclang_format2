// Source: Classes/SimpleNumber.schelp block 13
(
{ var saw = LFSaw.ar(2 * 0.01.reciprocal);
	[saw, saw.softclip]
}.plot.superpose_(true)
)
