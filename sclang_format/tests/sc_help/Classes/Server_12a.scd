// Source: Classes/Server.schelp block 12 (part 1/2)
(
t = TempoClock;
t.tempo = 1;

s.waitForBoot({
	var win, routine;
	defer {
		win = Window();
		win.background_(Color.grey(0, 0)).onClose_{ routine.stop }.front;
	};
	routine = fork {
		9.do { |i|
			1.wait;
			{ win.background_(Color.rand) }.defer;
			i = if (i % 4 == 0) { 93 } { 81 };
			x = {
				SinOsc.ar(i.midicps) * Env.perc.ar(Done.freeSelf) * [0.1, -0.1]
			}.play
		};
		defer { win.close }
	}
}, clock: t)
)
