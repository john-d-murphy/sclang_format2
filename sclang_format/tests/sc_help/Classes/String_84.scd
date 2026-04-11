// Source: Classes/String.schelp block 84
(
w = Window.new.front;
r = Rect(100, 100, 100, 100);
w.view.background_(Color.white);
w.drawFunc = {
	"abababababa\n\n\n".scramble.drawInRect(r, Font("Courier", 12), Color.blue(0.3, 0.5));
	Pen.strokeRect(r);
};
w.refresh;
)
