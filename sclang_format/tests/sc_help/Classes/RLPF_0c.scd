// Source: Classes/RLPF.schelp block 0 (part 3/3)
(
{ var ctl = RLPF.ar(Saw.ar(5,0.1), MouseX.kr(2, 200, 1), MouseY.kr(0.01, 1, 1));
	SinOsc.ar(ctl * 200 + 400) * 0.1;
}.play;
)
