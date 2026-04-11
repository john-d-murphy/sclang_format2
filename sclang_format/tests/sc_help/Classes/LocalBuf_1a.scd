// Source: Classes/LocalBuf.schelp block 1 (part 1/2)
SynthDef(\bigLocalBuf, {
	LocalBuf(88200).set(Array.fill(88200, { #[0, 0.25, 0.5, 0.75, 1.0].choose }))
}).add;
