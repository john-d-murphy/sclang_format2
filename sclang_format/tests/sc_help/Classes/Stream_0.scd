// Source: Classes/Stream.schelp block 0
(
	f = { 33.rand };
	x = FuncStream(f);
	10.do({ [f.next, x.next].postln });
)
