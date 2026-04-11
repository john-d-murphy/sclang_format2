// Source: Classes/LinLin.schelp block 0 (part 1/3)
(
{
	var mod = SinOsc.kr(Line.kr(1, 10, 10));
	SinOsc.ar(LinLin.kr(mod, -1,1, 100, 900)) * 0.1
}.play;
)
