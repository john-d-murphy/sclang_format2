// Source: Classes/PdurStutter.schelp block 0 (part 1/4)
(
a = PdurStutter(
	Pseq(#[1,1,1,1,1,2,2,2,2,2,0,1,3,4,0],inf),
	Pseq(#[0.5, 1, 2, 0.25,0.25],inf)
);
x = a.asStream;
100.do({ x.next.postln; });
)
