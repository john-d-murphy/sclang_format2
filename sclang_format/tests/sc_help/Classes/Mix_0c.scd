// Source: Classes/Mix.schelp block 0 (part 3/4)
(
play({
	Mix.new(Array.fill(8, { SinOsc.ar(500 + 500.0.rand, 0, 0.05) }));
}))
