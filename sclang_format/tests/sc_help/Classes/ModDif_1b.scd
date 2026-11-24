// Source: Classes/ModDif.schelp block 1 (part 2/2)
(
{
	var numChan = 12;
	var x = SinOsc.ar({ rrand(300.0, 800.0) } ! numChan);
	var dist = ModDif.kr(MouseX.kr(0, numChan * 2), (0..numChan-1), numChan);
	x = x * max(0, 1 - dist);
	Splay.ar(x) * 0.1
}.play;
)
