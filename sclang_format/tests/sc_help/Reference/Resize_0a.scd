// Source: Reference/Resize.schelp block 0 (part 1/2)
(
var a;

a = { |i|
	var w, b, x,k,t,p;
	k=i;
	i = i + 1;
	w = Window("resize:"+i, Rect(10 + (k%3 * 220), Window.screenBounds.height- [250,460,670].at(k/3), 200, 180));
	b = w.view.bounds;
	x = CompositeView(w, w.view.bounds.insetBy(20,20))
		.background_(Color.rand)
		.resize_(i);

	y = CompositeView(x, x.bounds.moveTo(0,0).insetBy(20,20))
		.background_(Color.rand)
		.resize_(i);

	y.decorator = FlowLayout(y.bounds).gap_(0.0 @ 0.0);

	t = StaticText(y, Rect(0, 0, 40, 40))
		.background_(Color.rand.alpha_(0.8))
		.resize_(i)
		.string_(i)
		.font_(Font("Helvetica", 26));

	p=PopUpMenu(y,40@40).items_((1..9).collect(_.asString)).value_(i-1).resize_(i)
			.action_{|m| t.string_((m.value+1).asString); [p,t].do(_.resize_(m.value+1))};

	w.front;
	w.onClose = {a.do(_.close) };

} ! 9;
)
