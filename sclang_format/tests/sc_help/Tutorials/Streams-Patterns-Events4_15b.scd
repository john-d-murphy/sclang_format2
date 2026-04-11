// Source: Tutorials/Streams-Patterns-Events4.schelp block 15 (part 2/2)
(
var pattern, stream;
pattern =
	Prand([
		Pbind( \abc, Pseq([1, 2, 3])),
		Pbind( \def, Pseq([4, 5, 6])),
		Pbind( \xyz, Pseq([7, 8, 9]))
	], 3);
stream = pattern.asStream;
10.do({ stream.next(Event.new).postln; });
)
