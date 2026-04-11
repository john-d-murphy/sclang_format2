// Source: Classes/Prewrite.schelp block 1 (part 2/2)
(
a = Prewrite(0, // start with 0
	(
		0: #[2,0],
		1: #[0,0,1],
		2: #[1,0,1]
), 4);
x = a.asStream;
30.do({ x.next.postln });
)
