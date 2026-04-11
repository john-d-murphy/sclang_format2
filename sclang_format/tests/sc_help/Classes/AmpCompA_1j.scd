// Source: Classes/AmpCompA.schelp block 1 (part 10/11)
(
{
	var freq;
	freq = MouseX.kr(300, 15000, 1);
	freq = freq * SinOsc.ar(MouseY.kr(3, 200, 1), 0, 0.5, 1);
	SinOsc.ar(freq) * 0.1
}.play;
)
