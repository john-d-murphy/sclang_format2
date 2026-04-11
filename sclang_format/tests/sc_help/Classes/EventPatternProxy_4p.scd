// Source: Classes/EventPatternProxy.schelp block 4 (part 16/28)
(
x.source = Pbind(
	\dur, 0.25,
	\degree, Pseq([3, 4, Prand([8, 2, 3, 9, 10],1), 6], inf),
	\instrument, \gpdef
)
)
