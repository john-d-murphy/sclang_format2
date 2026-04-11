// Source: Classes/InBus.schelp block 0
(
b = Bus.control(s, 9); // nine channel control rate
b.setn([244, 737, 20, 271, 382, 172, 4, 2399, 251]);
{
	var index = MouseX.kr(0, 30);
	Blip.ar(InBus.ar(b, 2, index, \wrap)) * 0.1
}.play;
)
