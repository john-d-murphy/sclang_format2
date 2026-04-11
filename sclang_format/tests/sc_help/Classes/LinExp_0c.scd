// Source: Classes/LinExp.schelp block 0 (part 3/3)
(
{
	var mod = LFNoise2.ar(80);
	SinOsc.ar(LinExp.ar(mod, -1,1, MouseX.kr(200, 8000, 1), MouseY.kr(200, 8000, 1))) * 0.1
}.play;
)
