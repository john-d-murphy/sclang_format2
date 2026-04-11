// Source: Classes/Image.schelp block 19 (part 1/5)
(
	j = Image.new(400,300);
	j.draw({ arg image;

		Pen.translate(100, 100);
		1000.do {
			// set the Color
			Pen.color = Color.green(rrand(0.0, 1), rrand(0.0, 0.5));
			Pen.addAnnularWedge(
				(100.rand)@(100.rand),
				rrand(10, 50),
				rrand(51, 100),
				2pi.rand,
				2pi.rand
			);
			Pen.perform([\stroke, \fill].choose);
		};
	}).plot(freeOnClose:true);
)
