// Source: Tutorials/Streams-Patterns-Events4.schelp block 13
(
var pattern, stream;

	// bind Symbol xyz to values obtained from a pattern
pattern = Pbind(
	\xyz, Pseq([1, 2, 3])
);

	// create a stream of events for the Pbind pattern.
stream = pattern.asStream;

	// event Streams require a prototype event as input.
	// this example uses an empty Event as a prototype
4.do({ stream.next(Event.new).postln; });
)
