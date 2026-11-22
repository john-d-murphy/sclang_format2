// Source: Classes/CondVar.schelp block 1 (part 1/2)
(
c = CondVar();

Routine {
	1.wait;
	"waited for 1 second".postln;
	1.wait;
	"waited for another second, now waiting for you to run 'c.signalOne'...".postln;
	c.wait;
	"the condition is no longer waiting".postln;
	1.wait;
	"waited for another second, now waiting for you...".postln;
	c.wait;
	"the condition is no longer waiting".postln;
	1.wait;
	"the end".postln;
}.play;
)
