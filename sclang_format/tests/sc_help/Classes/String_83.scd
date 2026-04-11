// Source: Classes/String.schelp block 83
(
w = Window.new.front;
w.view.background_(Color.white);
w.drawFunc = {
	"abababababa\n\n\n".scramble.drawAtPoint(
		100@100,
		Font("Courier", 30),
		Color.blue(0.3, 0.5))
};
w.refresh;
)
