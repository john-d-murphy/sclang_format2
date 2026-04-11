// Source: Classes/SelectXFocus.schelp block 0
(
{
	var array = { Saw.ar(rrand(1.0, 3.0)) * Saw.ar(rrand(100.0, 3000.0)) } ! 8;
	SelectXFocus.ar(MouseX.kr(-20, 20), array, 0.3, true) * 0.1
}.play
)
