// Source: Classes/StaticText.schelp block 2
(
w = Window.new.front;
w.view.background=Color.white;
a = Array.fill(20, { StaticText(w, Rect(w.bounds.extent.x.rand, w.bounds.extent.y.rand, 160, 16))
	.string_("Rolof's Rolex".scramble)
	.align_(\center)
	.stringColor_(Color.rand)
	.font_(Font([
		"Helvetica-Bold",
		"Helvetica",
		"Monaco",
		"Arial",
		"Gadget",
		"MarkerFelt-Thin"
	].choose, 11))
});

r = {
	inf.do { |i|
		thisThread.randSeed_(1284);
		a.do { |item|
			// setting GUI values is asynchronous, so you must use .defer
			{
				item.bounds = Rect(
					5 + w.bounds.extent.x.rand * abs(cos(i * 0.01)),
					w.bounds.extent.y.rand * sin(i * 0.01),
					160,
					20
				)
			}.defer;
		};
		0.15.wait;
	}
}.fork;
CmdPeriod.doOnce({ w.close });
w.onClose_({ r.stop });
)
