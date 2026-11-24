// Source: Tutorials/GUI/create_simple_instrument_view.schelp block 12
(
var window = Window();
var windowLayout = VLayout();
var pianoLayout = HLayout();
var frequencies = [60, 62, 64, 65, 67, 69, 71, 72].midicps;

// Slider setup
var volumeSlider = Slider()
.orientation_(\horizontal)
.maxHeight_(60);

frequencies.do({ |frequency|
	var button = Button()
	.maxHeight_(200);
	button.action_({ Synth(\instrView, [\freq, frequency]); });
	pianoLayout.add(button);
});

windowLayout.add(volumeSlider);
windowLayout.add(pianoLayout);
window.layout_(windowLayout);
window.front;
)
