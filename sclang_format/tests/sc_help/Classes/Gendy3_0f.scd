// Source: Classes/Gendy3.schelp block 0 (part 6/17)
(
{ Pan2.ar(Mix.new(
	Gendy3.ar(3, 5, 1.0, 1.0, (Array.fill(5, { LFNoise0.kr(1.3.rand, 1, 2) })*MouseX.kr(100, 378, 'exponential')), MouseX.kr(0.01, 0.05), MouseY.kr(0.001, 0.016), 5, mul: 0.1)
))}.play
)
