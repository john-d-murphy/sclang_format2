// Source: Classes/Prout.schelp block 0 (part 4/4)
(
Pbind(
	\instrument, \help_sinegrain,
	\freq, p { loop { ([1000, 2000].choose + [100, 200].choose + [10, 20].choose).postln.yield } },
	\dur, 0.1
).play;
)
