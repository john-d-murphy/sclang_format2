// Source: Classes/SimpleNumber.schelp block 6
(
fork {
	1.wait;
	"I did wait".postln;
	1.0.rand.wait;
	"No you didn't".postln;
	2.wait;
	(1..).do { |i|
		"yes I did".postln;
		i.asFloat.rand.wait;
		"no you didn't".postln;
		i.wait
	}
}
)
