// Source: Classes/LFGauss.schelp block 4 (part 8/9)
(
{
	var mod = LFGauss.ar(MouseX.kr(1, 0.07, 1), 1 * (MouseY.kr(1, 3) ** (-1..-6)));
	var carr = SinOsc.ar(200 * (1.3 ** (0..5)));
	(carr * mod).sum * 0.1
}.play;
)
