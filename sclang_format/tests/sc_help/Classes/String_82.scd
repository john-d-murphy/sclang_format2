// Source: Classes/String.schelp block 82
(
w = Window.new.front;
w.view.background_(Color.white);
w.drawFunc = {
	"abababababa\n\n\n".scramble.draw
};
w.refresh
)
