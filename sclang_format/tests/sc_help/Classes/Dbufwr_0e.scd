// Source: Classes/Dbufwr.schelp block 0 (part 5/11)
(
{
	var val = MouseY.kr(1000, 200, 1); // cursor y pos controls frequency
	var pos = MouseX.kr(0, BufFrames.kr(b) - 1); // cursor x position controls buffer pos
	var write = MouseButton.kr; // button controls write action
	Demand.kr(write, 0, Dbufwr(val, b, pos, 1));
	SinOsc.ar(
		Duty.kr(Dseq([0.5, 0.75, 0.5, 1.0], inf) * 0.2, 0, Dbufrd(b, Dseries(0, 1, inf)))
	) * 0.1
}.play;
)
