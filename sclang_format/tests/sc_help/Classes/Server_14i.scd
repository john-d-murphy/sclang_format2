// Source: Classes/Server.schelp block 14 (part 9/13)
(
try {
	s.makeBundle(nil, {
		s.farkermartin;
	});
} { |error|
	("Look Ma, normal operations resume even though:\n" + error.errorString).postln;
	x = { FSinOsc.ar(440, 0, 0.2) }.play; // This works fine
}
)
