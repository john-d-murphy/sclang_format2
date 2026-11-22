// Source: Classes/Image.schelp block 8 (part 1/4)
(
	w = Window.new;
	w.front; // comment this to copy offscreen window
	w.view.background_(Color.white);
	w.drawHook = {
		Pen.translate(100, 100);
		10.do{
			// set the Color
			Pen.color = Color.blue(rrand(0.0, 1), rrand(0.0, 0.5));
			Pen.addWedge((100.rand)@(100.rand), rrand(10, 100), 2pi.rand, 2pi.rand);
			Pen.perform([\stroke, \fill].choose);
		}
	};
	w.refresh;
)
