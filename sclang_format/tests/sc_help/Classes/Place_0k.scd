// Source: Classes/Place.schelp block 0 (part 11/11)
(
c = Place(#[0, 0, [0, 4, 7], [1, 5, 8], [2, 6, 9]], inf) + 67;
x = c.asStream;
Routine({
	loop({
		Synth("help-sinegrain", [\freq, x.next.midicps]);
		0.17.wait;
	})
}).play;
)
