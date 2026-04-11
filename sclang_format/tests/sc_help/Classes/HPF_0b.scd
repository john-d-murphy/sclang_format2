// Source: Classes/HPF.schelp block 0 (part 2/3)
(
{ 	var ctl = HPF.kr(LFSaw.kr(5), SinOsc.kr(XLine.kr(0.07, 30, 20), 0, 35, 40)) ;
	SinOsc.ar(ctl * 200 + 500);
}.play;
)
