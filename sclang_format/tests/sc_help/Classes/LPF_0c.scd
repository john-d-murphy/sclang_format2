// Source: Classes/LPF.schelp block 0 (part 3/3)
(
{ var ctl = LPF.kr(LFPulse.kr(8), MouseX.kr(2, 50, 1));
	SinOsc.ar(ctl * 200 + 400)
}.play;
)
