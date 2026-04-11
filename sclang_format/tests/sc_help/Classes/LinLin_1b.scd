// Source: Classes/LinLin.schelp block 1 (part 2/2)
(
{
	var mod = LFNoise2.ar(80).range(MouseX.kr(200, 8000, 1), MouseY.kr(200, 8000, 1));
	SinOsc.ar(mod) * 0.1
}.play;
)
