// Source: Classes/Condition.schelp block 2 (part 1/6)
(
c = Condition.new(false);

Routine {
	1.wait;
	"waited for 1 second".postln;
	1.wait;
	"waited for another second, now waiting for you ... ".postln;
	c.wait;
	"the condition has stopped waiting.".postln;
	1.wait;
	"waited for another second".postln;
	"waiting for you ... ".postln;
		c.test = false;
		c.wait;
	"the condition has stopped waiting.".postln;
	1.wait;
	"the end".postln;
}.play;
)
