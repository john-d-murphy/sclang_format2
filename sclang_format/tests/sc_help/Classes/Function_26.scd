// Source: Classes/Function.schelp block 26
(
var f = {|degree, stepsPerOctave, acc|
	(1.8 ** (degree % stepsPerOctave) + acc).postln
};
Pbind(
	\scale, f,
	\degree, Pseq([0, 1, 2b, 3s, 4s, 6, 14, [0, 2, 4], [1, 3, 6]], inf)
).play
)
