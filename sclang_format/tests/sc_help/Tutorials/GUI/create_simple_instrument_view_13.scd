// Source: Tutorials/GUI/create_simple_instrument_view.schelp block 13
(
var window = Window();
var windowLayout = VLayout();
var pianoLayout = HLayout();
var frequencies = [60, 62, 64, 65, 67, 69, 71, 72].midicps;

// Create a variable to store the volume
var volume = 0.1;

var volumeSlider = Slider()
.orientation_(\horizontal)
.maxHeight_(60)
// Make the slider start at the correct value
.value_(volume);

// When the slider moves, update the volume variable
volumeSlider.action = {
	volume = volumeSlider.value;
};

frequencies.do({ |frequency|
	var button = Button()
	.maxHeight_(200);
	button.action_({
		// Use the volume variable
		// to modify the Synth arguments
		// when the key is pressed
		Synth(\instrView, [
			\freq, frequency,
			\amp, volume
		]);

	});
	pianoLayout.add(button);
});

windowLayout.add(volumeSlider);
windowLayout.add(pianoLayout);
window.layout_(windowLayout);
window.front;
)
