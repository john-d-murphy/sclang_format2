// Source: Classes/LFGauss.schelp block 2 (part 7/7)
(
{
	var width = XLine.kr(0.04, 1.0, 1);
	LFGauss.ar(0.1, width, loop: 1).range(0, 1);
}.plot(1)
);
