// Source: Classes/LFGauss.schelp block 4 (part 7/9)
(
{ 	var dur = SinOsc.ar(MouseX.kr(2, 1000, 1) * [1, 1.1]).range(0.0006, 0.01);
	var width = SinOsc.ar(0.5 * [1, 1.1]).range(0.01, 0.3);
	LFGauss.ar(dur, width) * 0.2
}.play
);
