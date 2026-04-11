// Source: Classes/CompositeView.schelp block 5
(
w = Window.new.front;
v = CompositeView.new(w, w.view.bounds.insetBy(10)).background_(Color.rand);
v.decorator = FlowLayout(v.bounds);

l = "SUPERCOLLIDER".scramble;
t = Array.fill(9, {arg i; var n, r, q;
	n = CompositeView.new(v, Rect(20, 20, 121, 121)).background_(Color.rand);
	q = StaticText(n, n.bounds.moveTo(0,0).insetBy(25)).string_(l[i]).align_(\center);
	q.enabled = true;
	q.font = Font("Geneva", 10);
	q.background_(Color.rand);
	q.mouseDownAction = {
		n.background_(Color.rand);
		q.font=q.font.size_(5 + q.font.size + 7 % 60)
	};
});
)
