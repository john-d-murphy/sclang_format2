// Source: Classes/Stream.schelp block 1
(
	f = { 33.rand };
	x = FuncStream(f, {thisThread.randSeed_(345)});
	x.reset;
	10.do({ [f.next, x.next].postln });
	x.reset;
	10.do({ [f.next, x.next].postln });
)
