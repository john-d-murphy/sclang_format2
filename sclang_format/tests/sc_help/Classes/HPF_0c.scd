// Source: Classes/HPF.schelp block 0 (part 3/3)
(
{ 	var ctl = HPF.kr(LFSaw.kr(5, 0.1), MouseX.kr(2, 200, 1));
	SinOsc.ar(ctl * 200 + 400) * 0.1;
}.play;
)
