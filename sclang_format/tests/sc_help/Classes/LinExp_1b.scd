// Source: Classes/LinExp.schelp block 1 (part 2/2)
(
{
	var mod = LFNoise2.ar(80).exprange(MouseX.kr(200, 8000, 1), MouseY.kr(200, 8000, 1));
	SinOsc.ar(mod) * 0.1
}.play;
)
