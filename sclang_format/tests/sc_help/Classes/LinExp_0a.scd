// Source: Classes/LinExp.schelp block 0 (part 1/3)
(
{
	var mod = SinOsc.kr(Line.kr(1, 10, 10));
	SinOsc.ar(mod * 400 + 500) * 0.1
}.play;
)
