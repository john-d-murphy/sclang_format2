// Source: Classes/LinLin.schelp block 1 (part 1/2)
(
{
	var mod = LFNoise2.ar(80);
	SinOsc.ar(mod.linlin(-1,1, MouseX.kr(200, 8000, 1), MouseY.kr(200, 8000, 1))) * 0.1
}.play;
)
