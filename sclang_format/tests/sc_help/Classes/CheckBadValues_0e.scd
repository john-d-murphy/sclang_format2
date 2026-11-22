// Source: Classes/CheckBadValues.schelp block 0 (part 5/7)
(
x = { |freq = 440|
	var good;
	good = BinaryOpUGen('==', CheckBadValues.kr(freq, 0, 0), 0);
	SinOsc.ar(freq, 0, 0.1) * good // silence the output if freq is bad
}.play;
)
