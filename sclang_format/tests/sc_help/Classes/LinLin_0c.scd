// Source: Classes/LinLin.schelp block 0 (part 3/3)
(
{
	var mod = LFNoise2.ar(80);
	SinOsc.ar(
		LinLin.ar(mod,
			SinOsc.kr(0.2), SinOsc.kr(0.2543),
			MouseX.kr(200, 8000, 1), MouseY.kr(200, 8000, 1)
		)
	) * 0.1
}.play;
)
