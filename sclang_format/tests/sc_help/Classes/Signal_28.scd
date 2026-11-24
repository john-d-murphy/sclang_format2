// Source: Classes/Signal.schelp block 28
(
x = Signal.fill(512, { rrand(0.0, 1.0) });
y = Signal.fill(512, { |i| (i * pi / 64).sin });
[x, y, (x + y) * 0.5, x * y, min(x, y), max(x, y)].flop.flat
	.plot(numChannels: 6);
)
