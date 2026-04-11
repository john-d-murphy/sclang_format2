// Source: Classes/Shaper.schelp block 4 (part 5/8)
(
a = Signal.fill(256, { |i|
	var t = i/255.0;
	t + (0.1 * (max(t, 0.1) - 0.1) * sin(2pi * t * 80 + sin(2pi * 25.6 * t)))
})
);
