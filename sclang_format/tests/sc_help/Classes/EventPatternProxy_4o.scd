// Source: Classes/EventPatternProxy.schelp block 4 (part 15/28)
(
x.source = Pbind(
	\dur, 1 / 6,
	\degree, Pseq([3, 4, Prand([8, 2, 3, 9, 10],1) - 5, 6]+1, inf),
	\instrument, \gpdef
)
)
