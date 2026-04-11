// Source: Classes/SCImage.schelp block 18 (part 1/5)
(
	j = SCImage.new(400,300);
	j.draw({ arg image;

		SCPen.translate(100, 100);
		1000.do {
			// set the Color
			SCPen.color = Color.green(rrand(0.0, 1), rrand(0.0, 0.5));
			SCPen.addAnnularWedge(
				(100.rand)@(100.rand),
				rrand(10, 50),
				rrand(51, 100),
				2pi.rand,
				2pi.rand
			);
			SCPen.perform([\stroke, \fill].choose);
		};
	}).plot(freeOnClose:true);
)
