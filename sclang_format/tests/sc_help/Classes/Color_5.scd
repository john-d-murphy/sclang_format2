// Source: Classes/Color.schelp block 5
(
w = Window.new.front;
w.view.background_(Color.white);
w.drawFunc = {
	// set the Color
	Pen.translate(200, 200);
	30.do{
		Pen.width = 3.0.rand;
		Color.blue(rrand(0.0, 1), rrand(0.0, 0.5)).setStroke;
		Color.red(rrand(0.0, 1), rrand(0.0, 0.5)).setFill;
		Pen.addAnnularWedge(
			0@0,
			rrand(10, 50),
			rrand(51, 100),
			2pi.rand,
			2pi.rand
		);
		Pen.perform([\stroke, \fill].choose);
	}
};
w.refresh;
)
