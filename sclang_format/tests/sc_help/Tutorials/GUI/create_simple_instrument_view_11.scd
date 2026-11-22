// Source: Tutorials/GUI/create_simple_instrument_view.schelp block 11
(
var window = Window();
var windowLayout = VLayout();
var pianoLayout = HLayout();

var frequencies = [60, 62, 64, 65, 67, 69, 71, 72].midicps;

var volumeSlider = Slider();

frequencies.do({ |frequency|
	var button = Button()
	.maxHeight_(200);
	button.action_({ Synth(\instrView, [\freq, frequency]); });
	// Horizontal split, 'piano layout'
	pianoLayout.add(button);
});

// Vertical split, 'window' layout
windowLayout.add(volumeSlider);
windowLayout.add(pianoLayout);

window.layout_(windowLayout);
window.front;
)
