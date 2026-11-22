// Source: Classes/TaskProxy.schelp block 2 (part 6/8)
(
b = TaskProxy.new;
b.source = {
	"counting...".postln;
	2.wait;
	a.embedInStream;
	1.wait;
	c.embedInStream;
	"done.".postln;
};
)
