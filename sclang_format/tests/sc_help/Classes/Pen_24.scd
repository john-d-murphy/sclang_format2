// Source: Classes/Pen.schelp block 24
(
var w, phase = 0, seed = Date.seed, run = true;
w = Window("my name is... panel", Rect(128, 64, 800, 800));
w.view.background = Color.blue(0.4);
w.onClose = { run = false };
w.front;
w.drawFunc = {
	Pen.use {
		if (0.02.coin) { seed = Date.seed };
		thisThread.randSeed = seed;
		Pen.strokeColor = Color.white;
		200.do {
			var a = 4.rand;
			var b = 24.rand;
			var r1 = 230 + (50 * a);
			var a1 = 2pi / 24 * b + phase;
			var r2 = 230 + (50 * (a + 1.rand2).fold(0, 3));
			var a2 = 2pi / 24 * (b + (3.rand2)).wrap(0, 23) + phase;
			Pen.width = 0.2 + 1.0.linrand;
			Pen.beginPath;
			Pen.moveTo(Polar(r1, a1).asPoint + Point(400, 400));
			Pen.lineTo(Polar(r2, a2).asPoint + Point(400, 400));
			Pen.stroke;
		};
		thisThread.randSeed = Date.seed;
		40.do {
			var a = 4.rand;
			var b = 24.rand;
			var r1 = 230 + (50 * a);
			var a1 = 2pi / 24 * b + phase;
			var r2 = 230 + (50 * (a + 1.rand2).fold(0, 3));
			var a2 = 2pi / 24 * (b + (3.rand2)).wrap(0, 23) + phase;
			Pen.width = 0.2 + 1.5.linrand;
			Pen.beginPath;
			Pen.moveTo(Polar(r1, a1).asPoint + Point(400, 400));
			Pen.lineTo(Polar(r2, a2).asPoint + Point(400, 400));
			Pen.stroke;
		};
	};
};

{ while { run } { w.refresh; 0.1.wait; phase = phase + (2pi/(20*24)) } }.fork(AppClock)

)
