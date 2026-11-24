// Source: Tutorials/GUI/create_simple_instrument_view.schelp block 6
(
var window = Window();
var layout = HLayout();
var numberOfButtons = 8;

numberOfButtons.do({

	// Changing this property
	var button = Button()
	.maxHeight_(200);

	button.action_({ Synth(\instrView); });
	layout.add(button);
});

window.layout_(layout);
window.front;
)
