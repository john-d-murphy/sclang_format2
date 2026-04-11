// Source: Classes/String.schelp block 85
(
w = Window.new.front;
w.view.background_(Color.white);
r = Rect(100, 100, 100, 100);
w.drawFunc = {
	"abababababa\n\n\n".scramble.drawCenteredIn(
		r,
		Font("Courier", 12),
		Color.blue(0.3, 0.5)
	);
	Pen.strokeRect(r);
};
w.refresh;
)
