// Source: Tutorials/GUI/create_simple_instrument_view.schelp block 9
(
var window = Window();
var layout = HLayout();
var frequencies = [60, 62, 64, 65, 67, 69, 71, 72].midicps;

// Slider creation
var slider = Slider();

frequencies.do({ |frequency|
	var button = Button()
	.maxHeight_(200);
	button.action_({ Synth(\instrView, [\freq, frequency]); });
	layout.add(button);
});

// Add it inside the layout
layout.add(slider);

window.layout_(layout);
window.front;
)
