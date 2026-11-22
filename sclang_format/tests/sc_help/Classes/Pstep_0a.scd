// Source: Classes/Pstep.schelp block 0 (part 1/9)
(
// select a chord and duration and repeat it for a random time interval
p = Pstep(
	Pbind(
		\ctranspose, [0, 4, 7],
		\note,	Pwhite(0, 12),
		\dur,	Prand([0.2, 0.4, 0.8], inf)
	),
	Prand([1, 2, 4], inf)/4
);
Ppar([p, p]).play;
)
