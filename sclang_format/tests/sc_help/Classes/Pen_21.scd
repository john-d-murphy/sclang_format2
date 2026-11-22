// Source: Classes/Pen.schelp block 21
(
var w, run = true;
w = Window("my name is... panel", Rect(128, 64, 800, 800));
w.view.background = Color.white;
w.onClose = { run = false };
w.front;
w.drawFunc = {
	Pen.use {
		Pen.width = 0.2;
		400.do {
			Pen.beginPath;
			Pen.moveTo(Point(10.rand * 80 + 40, 10.rand * 80 + 40));
			Pen.lineTo(Point(10.rand * 80 + 40, 10.rand * 80 + 40));
			Pen.stroke;
		};
	};
};

{ while { run } { w.refresh; 1.0.rand.wait } }.fork(AppClock)

)
