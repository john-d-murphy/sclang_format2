// Source: Tutorials/Streams-Patterns-Events4.schelp block 14
(
var pattern, stream;

pattern = Pbind(
	\abc, Prand([6, 7, 8, 9], inf ),
	\xyz, Pseq([1, 2, 3], 2 ),
	\uuu, 999 // a constant represents an infinite sequence of itself
);

stream = pattern.asStream;

7.do({ stream.next(Event.new).postln; });
)
