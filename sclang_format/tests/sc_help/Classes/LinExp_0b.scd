// Source: Classes/LinExp.schelp block 0 (part 2/3)
(
{
	var mod = SinOsc.kr(Line.kr(1, 10, 10));
	SinOsc.ar(LinExp.kr(mod, -1,1, 100, 900)) * 0.1
}.play;
)
