// Source: Classes/Pfsm.schelp block 0 (part 2/3)
(
a = Pfsm([
		#[0, 1],
		67, #[0, 0, 3],
		72, #[2],
		73, #[0, 2],
		Pseq([74, 75, 76, 77]), #[2, 3, 3],
		nil, nil
	], inf).asStream;
Routine({
	loop({
		Synth(\help_sinegrain, [\freq, a.next.midicps]);
		0.1.wait;
	})
}).play;
)
