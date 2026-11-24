// Source: Classes/Pen.schelp block 22
(
var w, run = true;
w = Window("my name is... panel", Rect(128, 64, 800, 500));
w.view.background = Color.white;
w.onClose = { run = false };
w.front;
w.drawFunc = {
	Pen.use {
		Pen.width = 2;
		80.do {
			Pen.width = rrand(0, 4) + 0.5;
			Pen.beginPath;
			Pen.moveTo(Point(800.rand, 500.rand));
			Pen.lineTo(Point(800.rand, 500.rand));
			Pen.stroke;
		};
	};
};

{ while { run } { w.refresh; 1.0.rand.wait } }.fork(AppClock)

)
