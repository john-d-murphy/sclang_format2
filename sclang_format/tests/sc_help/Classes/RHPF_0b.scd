// Source: Classes/RHPF.schelp block 0 (part 2/2)
(
{ 	var ctl = RHPF.kr(LFSaw.kr(2), SinOsc.kr(XLine.kr(0.07,30,20), 0, 35, 40), 0.05);
	SinOsc.ar(ctl * 200 + 500);
}.play;
)
