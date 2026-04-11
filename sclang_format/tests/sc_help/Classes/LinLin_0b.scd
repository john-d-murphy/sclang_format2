// Source: Classes/LinLin.schelp block 0 (part 2/3)
(
{
	var mod = LFNoise2.ar(80);
	SinOsc.ar(LinLin.ar(mod, -1,1, MouseX.kr(200, 8000, 1), MouseY.kr(200, 8000, 1))) * 0.1
}.play;
)
