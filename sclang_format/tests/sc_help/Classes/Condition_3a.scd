// Source: Classes/Condition.schelp block 3 (part 1/2)
(
c = Condition.new;

Routine {
	1.wait;
	"waited for 1 second".postln;
	1.wait;
	"waited for another second, now waiting for you ... ".postln;
	c.hang;
	"the condition has stopped waiting.".postln;
	1.wait;
	"waited for another second".postln;
	"waiting for you ... ".postln;
	c.hang;
	"the condition has stopped waiting.".postln;
}.play;
)
