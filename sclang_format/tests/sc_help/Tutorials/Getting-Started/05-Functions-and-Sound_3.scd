// Source: Tutorials/Getting-Started/05-Functions-and-Sound.schelp block 3
(
{ var ampOsc;
	ampOsc = SinOsc.kr(0.5, 1.5pi, 0.5, 0.5);
	SinOsc.ar(440, 0, ampOsc);
}.play;
)
