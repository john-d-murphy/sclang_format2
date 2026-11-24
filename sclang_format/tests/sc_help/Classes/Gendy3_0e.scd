// Source: Classes/Gendy3.schelp block 0 (part 5/17)
(
{ Pan2.ar(Mix.new(
	Gendy3.ar(freq: ([1, 1.2, 1.3, 1.76, 2.3]*MouseX.kr(3, 17, 'exponential')), mul: 0.2)
))}.play
)
