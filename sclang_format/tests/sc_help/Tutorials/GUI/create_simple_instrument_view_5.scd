// Source: Tutorials/GUI/create_simple_instrument_view.schelp block 5
(
var window = Window();
var layout = HLayout();
var numberOfButtons = 8;

// 8 times...
numberOfButtons.do({
	// ...create a button...
	var button = Button();
	// ...assign its function...
	button.action_({ Synth(\instrView); });
	// ...and add it to the layout.
	layout.add(button);
});

window.layout_(layout);
window.front;
)
