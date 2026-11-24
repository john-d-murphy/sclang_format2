// Source: Classes/Penvir.schelp block 0 (part 3/6)
(
x = (a: 8);
y = Penvir(
	x,
	Pfunc { ~a = ~a * 2 }
);

t = y.asStream;
z = y.asStream;
)
