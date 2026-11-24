// Source: Classes/LFGauss.schelp block 2 (part 6/7)
(
{
	var width = XLine.kr(0.04, 1.0, 1);
	var min = (exp(1.0 / (-2.0 * squared(width))));
	var gauss = LFGauss.ar(0.1, width, loop: 1);
	gauss.linlin(min, 1, 0, 1);
}.plot(1)
);
