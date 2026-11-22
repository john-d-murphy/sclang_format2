// Source: Classes/TaskProxy.schelp block 2 (part 1/8)
(
#a, c = { TaskProxy.new } ! 2;
a.source = { "one".postln; 1.wait; "two".postln };
c.source = { var z; z = Synth(\default); 0.5.wait; z.release };
r = Task {
	"counting...".postln;
	2.wait;
	a.embedInStream;
	1.wait;
	c.embedInStream;
	"done.".postln;
};
)
