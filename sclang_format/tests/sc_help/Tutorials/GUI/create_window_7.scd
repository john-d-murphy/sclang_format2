// Source: Tutorials/GUI/create_window.schelp block 7
(
var window = Window();
var button = Button(
	window,
	Rect(100, 100, 200, 200)
);
button.string_("Click me!");
window.front;
)
